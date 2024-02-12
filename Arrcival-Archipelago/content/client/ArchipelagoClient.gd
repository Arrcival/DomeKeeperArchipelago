extends Node

var _ap_server: String = ""
var _ap_user: String = ""
var _ap_pass: String = ""

const my_version = "1.0.0"
const ap_version = {"major": 0, "minor": 4, "build": 4, "class": "Version"}
const GAME_NAME = "Dome Keeper"

var _client
var _should_process = false
var _initiated_disconnect = false
var _try_wss = false

var _datapackages = {}
var _pending_packages = []
var _item_id_to_name = {}  # All games
var _location_id_to_name = {}  # All games
var _item_name_to_id = {}  # Game only
var _location_name_to_id = {}  # Game only

var _remote_version = {"major": 0, "minor": 0, "build": 0}
const color_items = [
	"White", "Black", "Red", "Blue", "Green", "Brown", "Gray", "Orange", "Purple", "Yellow"
]

# TODO: caching per MW/slot, reset between connections
var _authenticated = false
var _seed: String = ""
var _team = 0
var _slot = 0
var _players = []
var _player_name_by_slot = {}
var _checked_locations = []
var _slot_data = {}
var _keeper: int
var _dome: int
var _domeGadget: int
var _mapSize: int
var _difficulty: int
var _switchesAmount: int
var _death_link = false
var _received_indexes = []

var slotSeed: int = 0


signal could_not_connect(errorMessage)
signal connect_status(message)
signal client_connected(message)
signal evaluate_solvability

signal onDeathFound
signal item_received(itemId)
signal connected
signal connectedWithRoomInfo
signal packetRoomInfo
signal packetConnected
signal logInformations(informations)

var is_connected = false

func _init():
	ProjectSettings.set_setting("network/limits/websocket_client/max_in_buffer_kb", 8192)
	_client = WebSocketClient.new()
	print("Instantiated APClient")
	GameWorld.archipelago.client = self

func _ready():
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_failed", self, "_closed")
	_client.connect("server_disconnected", self, "_closed")
	_client.connect("connection_error", self, "_errored")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")
	_client.connect("server_close_request", self, "_server_closed")
	print("AP client ready")

# mandatory to receive/emit
func _process(_delta):
	if _should_process:
		_client.poll()

# signals received from the client
func _reset_state():
	_should_process = false
	_authenticated = false
	_try_wss = false

func _server_closed(code: int, reason: String):
	print("Error " + str(code) + " : " + reason)
	
func _closed(_was_clean = true):
	print("Connection closed")
	_reset_state()

	if not _initiated_disconnect:
		emit_signal("could_not_connect", "Disconnected from Archipelago")
	else:
		emit_signal("logInformations", "Connection closed")

	_initiated_disconnect = false

func _errored():
	if _try_wss:
		print("Could not connect to AP with ws://, now trying wss://")
		connectToServer(_ap_server, _ap_user, _ap_pass)
	else:
		print("AP connection failed")
		_reset_state()

		emit_signal(
			"could_not_connect",
			"Could not connect to Archipelago. Check that your server and port are correct. See the error log for more information."
		)

func _connected(_proto = ""):
	print("Connected!")
	emit_signal("client_connected", "Connected !")
	emit_signal("connected")
	is_connected = true
	_try_wss = false

func _on_data():
	var packet = _client.get_peer(1).get_packet()
	
	print("Got data from server: " + packet.get_string_from_utf8())
		
	var data = JSON.parse(packet.get_string_from_utf8())
	if data.error != OK:
		print("Error parsing packet from AP: " + data.error_string)
		return

	for message in data.result:
		var cmd = message["cmd"]
		
		print("Received command: " + cmd)

		if cmd == "RoomInfo":
			_seed = message["seed_name"]
			_remote_version = message["version"]

			var needed_games = []
			for game in message["datapackage_checksums"].keys():
				if (
					!_datapackages.has(game)
					or _datapackages[game]["checksum"] != message["datapackage_checksums"][game]
				):
					needed_games.append(game)

			emit_signal("packetRoomInfo")
			if !needed_games.empty():
				_pending_packages = needed_games
				var cur_needed = _pending_packages.pop_front()
				requestDatapackages([cur_needed])
			else:
				connectToRoom(_ap_user, _ap_pass)
		elif cmd == "Connected":
			_authenticated = true
			_team = message["team"]
			_slot = message["slot"]
			_players = message["players"]
			_checked_locations = message["checked_locations"]
			_slot_data = message["slot_data"]

			for player in _players:
				_player_name_by_slot[player["slot"]] = player["alias"]

			_death_link = _slot_data.has("deathLink") and _slot_data["deathLink"]
			
			if _death_link:
				_sendConnectUpdate(["DeathLink"])
			if _slot_data.has("seed"):
				slotSeed = int(_slot_data["seed"])
			if _slot_data.has("keeper"):
				_keeper = _slot_data["keeper"]
			if _slot_data.has("dome"):
				_dome = _slot_data["dome"]
			if _slot_data.has("domeGadget"):
				_domeGadget = _slot_data["domeGadget"]
			if _slot_data.has("mapSize"):
				_mapSize = _slot_data["mapSize"]
			if _slot_data.has("difficulty"):
				_difficulty = _slot_data["difficulty"]
			if _slot_data.has("switchesAmount"):
				_switchesAmount = _slot_data["switchesAmount"]
			_requestSync()

			emit_signal("packetConnected")
			emit_signal("logInformations", "Authenticated !")

		elif cmd == "ConnectionRefused":
			var error_message = ""
			for error in message["errors"]:
				var submsg = ""
				if error == "InvalidSlot":
					submsg = "Invalid player name."
				elif error == "InvalidGame":
					submsg = "The specified player is not playing " + GAME_NAME
				elif error == "IncompatibleVersion":
					submsg = (
						"The Archipelago server is not the correct version for this client. Expected v%d.%d.%d. Found v%d.%d.%d."
						% [
							ap_version["major"],
							ap_version["minor"],
							ap_version["build"],
							_remote_version["major"],
							_remote_version["minor"],
							_remote_version["build"]
						]
					)
				elif error == "InvalidPassword":
					submsg = "Incorrect password."
				elif error == "InvalidItemsHandling":
					submsg = "Invalid item handling flag. This is a bug with the client. Please report it to the lingo-archipelago GitHub."

				if submsg != "":
					if error_message != "":
						error_message += " "
					error_message += submsg

			if error_message == "":
				error_message = "Unknown error."

			_initiated_disconnect = true
			_client.disconnect_from_host()

			emit_signal("could_not_connect", error_message)
			print("Connection to AP refused")
			print(message)
			
		elif cmd == "DataPackage":
			for game in message["data"]["games"].keys():
				_datapackages[game] = message["data"]["games"][game]

			if !_pending_packages.empty():
				var cur_needed = _pending_packages.pop_front()
				requestDatapackages([cur_needed])
			else:
				processDatapackages()
				connectToRoom(_ap_user, _ap_pass)

		elif cmd == "ReceivedItems":
			var i = 0
			for item in message["items"]:
				processItem(item["item"], message["index"] + i, item["player"], item["flags"])
				i += 1
				
		elif cmd == "PrintJSON":
			if (
				!message.has("receiving")
				or !message.has("item")
				or message["item"]["player"] != _slot
			):
				continue

			var item_name = "Unknown"
			if _item_id_to_name.has(message["item"]["item"]):
				item_name = _item_id_to_name[message["item"]["item"]]

			var location_name = "Unknown"
			if _location_id_to_name.has(message["item"]["location"]):
				location_name = _location_id_to_name[message["item"]["location"]]

			var player_name = "Unknown"
			if _player_name_by_slot.has(message["receiving"]):
				player_name = _player_name_by_slot[message["receiving"]]

			var item_color = colorForItemType(message["item"]["flags"])

			if message["type"] == "Hint":
				var is_for = ""
				if message["receiving"] != _slot:
					is_for = " for %s" % player_name
				if !message.has("found") || !message["found"]:
					emit_signal("logInformations", 
						(
							"Hint: [color=%s]%s[/color]%s is on %s"
							% [item_color, item_name, is_for, location_name]
						)
					)
			else:
				if message["receiving"] != _slot:
					emit_signal("logInformations", 
						"Sent [color=%s]%s[/color] to %s" % [item_color, item_name, player_name]
					)
		elif cmd == "Bounced":
			if (
				_death_link
				and message.has("tags")
				and message.has("data")
				and message["tags"].has("DeathLink")
			):
				if message["data"].has("source") and message["data"]["source"] == _ap_user:
					return
				
				var first_sentence = "Received Death"
				var second_sentence = ""
				if message["data"].has("source"):
					first_sentence = "Received Death from %s" % message["data"]["source"]
				if message["data"].has("cause") and message["data"]["cause"] != "":
					second_sentence = ". Reason: %s" % message["data"]["cause"]
				emit_signal("logInformations", first_sentence + second_sentence)

				# Makes the dome explode !
				emit_signal("onDeathFound")

func _sendConnectUpdate(tags):
	sendMessage([{"cmd": "ConnectUpdate", "tags": tags}])
	
func _requestSync():
	sendMessage([{"cmd": "Sync"}])

func disconnect_from_ap():
	emit_signal("logInformations", "Disconnecting...")
	_initiated_disconnect = true
	_client.disconnect_from_host()

func sendLocation(loc_id: int):
	sendMessage([{"cmd": "LocationChecks", "locations": [loc_id]}])

func sendLocations(loc_ids: Array):
	print("Sent locations : ")
	print(loc_ids)
	sendMessage([{"cmd": "LocationChecks", "locations": loc_ids}])

func connectToServer(ap_server, ap_name, ap_pass):
	_initiated_disconnect = false
	_ap_server = ap_server
	_ap_user = ap_name
	_ap_pass = ap_pass

	var url = ""
	if ap_server.begins_with("ws://") or ap_server.begins_with("wss://"):
		url = ap_server
		_try_wss = false
	elif _try_wss:
		url = "wss://" + ap_server
		_try_wss = false
	else:
		url = "ws://" + ap_server
		_try_wss = true

	var err = _client.connect_to_url(url)
	if err != OK:
		emit_signal(
			"could_not_connect",
			(
				"Could not connect to Archipelago. Check that your server and port are correct. See the error log for more information. Error code: %d."
				% err
			)
		)
		print("Could not connect to AP: " + str(err))
		return
	_should_process = true

func processDatapackages():
	_item_id_to_name = {}
	_location_id_to_name = {}
	for package in _datapackages.values():
		for name in package["item_name_to_id"].keys():
			_item_id_to_name[package["item_name_to_id"][name]] = name

		for name in package["location_name_to_id"].keys():
			_location_id_to_name[package["location_name_to_id"][name]] = name

	if _datapackages.has(GAME_NAME):
		_item_name_to_id = _datapackages[GAME_NAME]["item_name_to_id"]
		_location_name_to_id = _datapackages[GAME_NAME]["location_name_to_id"]

func requestDatapackages(games):
	emit_signal("connect_status", "Downloading %s data package..." % games[0])

	sendMessage([{"cmd": "GetDataPackage", "games": games}])

func completedGoal():
	sendMessage([{"cmd": "StatusUpdate", "status": 30}])  # CLIENT_GOAL
	emit_signal("logInformations", "You have completed your goal!")

func processItem(item, index, from, flags):
	if index != null:
		if _received_indexes.has(index):
			# Do not re-process items.
			return

		_received_indexes.append(index)
		var item_name = "Unknown"
		if _item_id_to_name.has(item):
			item_name = _item_id_to_name[item]

		var item_color = colorForItemType(flags)
		emit_signal("item_received", item)
		# means its our own game, yay !
		if from == _slot:
			emit_signal("logInformations", "Found [color=%s]%s[/color]" % [item_color, item_name])
		# means its from someone else
		else:
			
			var player_name = "Unknown"
			if _player_name_by_slot.has(from):
				player_name = _player_name_by_slot[from]
			emit_signal("logInformations", 
				"Received [color=%s]%s[/color] from %s" % [item_color, item_name, player_name]
			)

func sendMessage(msg):
	var payload = JSON.print(msg)
	_client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
	_client.get_peer(1).put_packet(payload.to_utf8())

func connectToRoom(ap_user, ap_pass):	
	_ap_user = ap_user
	_ap_pass = ap_pass

	sendMessage(
		[
			{
				"cmd": "Connect",
				"password": ap_pass,
				"game": GAME_NAME,
				"name": ap_user,
				"uuid": GAME_NAME + ap_user,
				"version": ap_version,
				"items_handling": 0b111,  # always receive our items
				"tags": [],
				"slot_data": true
			}
		]
	)
	
func sendDeath(cause: String):
	if _death_link:
		sendMessage(
			[
				{
					"cmd": "Bounce",
					"tags": ["DeathLink"],
					"data": {
						"time": OS.get_unix_time(),
						"cause": cause,
						"source": _ap_user
					}
				}
			]
		)

func colorForItemType(flags):
	var int_flags = int(flags)
	if int_flags & 1:  # progression
		return "#bc51e0"
	elif int_flags & 2:  # useful
		return "#2b67ff"
	elif int_flags & 4:  # trap
		return "#d63a22"
	else:  # filler
		return "#14de9e"
