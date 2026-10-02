class_name ArchipelagoConnection

const CONSTARRC: GDScript = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

enum STATUS { DISCONNECTED = 0, IN_PROGRESS = 1, CONNECTED = 2}

var client: Variant
var server_name: String = ""
var slot_name: String = ""
var password: String = ""
var status: STATUS = STATUS.DISCONNECTED
var _pending_checks: Array[int] = []

signal slot_data_received(raw_slot_data: Dictionary)
signal scout_received(network_items: Array)
signal packet_connected
signal client_connected(message: String)
signal client_disconnected
signal connection_failed(message: String)
signal item_received(item_id: int, received_index: int)
signal death_link_received
signal connect_status(message: String)
signal connected_with_room_info
signal log_informations(text: String)

func connect_client() -> void:
	if client == null:
		push_error("Archipelago client is not available.")
		_set_disconnected()
		return

	var config: Dictionary = ModLoaderConfig.get_current_config(CONSTARRC.MOD_ID).data
	if config.has("server_uri"):
		server_name = config["server_uri"]
		print("Connecting to: ", server_name)
	if config.has("slot_name"):
		slot_name = config["slot_name"]
		print("With slot name: ", slot_name)
	if config.has("password"):
		password = config["password"]
		print("And password: ", password)

	_connect_client_signals()
	status = STATUS.IN_PROGRESS
	client.connect_to_server(server_name, slot_name, password)

func disconnect_client() -> void:
	_set_disconnected()
	if client != null:
		client.disconnect_from_ap()

func clear_pending_checks() -> void:
	_pending_checks.clear()

func reset_received_item_history() -> void:
	if client != null:
		client.reset_received_item_history()

func has_connection() -> bool:
	return status == STATUS.CONNECTED

func is_disconnected() -> bool:
	return status == STATUS.DISCONNECTED

func is_connecting() -> bool:
	return status == STATUS.IN_PROGRESS

func get_server_name() -> String:
	return server_name

func get_checked_locations() -> Array:
	if client == null:
		return []
	return client._checked_locations

func queue_location_check(location_id: int) -> void:
	if has_checked_location(location_id) or _pending_checks.has(location_id):
		return

	_pending_checks.append(location_id)
	process_pending_checks()

func process_pending_checks() -> void:
	if not has_connection():
		return

	while not _pending_checks.is_empty():
		var location_id: int = _pending_checks.front()
		if has_checked_location(location_id):
			_pending_checks.pop_front()
			continue

		if not send_check(location_id):
			return
		_pending_checks.pop_front()

func send_check(location_id: int) -> bool:
	if client == null or not has_connection():
		return false
	client.sendLocation(location_id)
	return true

func send_scout(location_ids: Array) -> void:
	if client == null or not has_connection():
		push_warning("Cannot scout locations while Archipelago is disconnected.")
		return
	client.sendScout(location_ids, 0)

func complete_goal() -> void:
	if client == null or not has_connection():
		return
	client.completedGoal()

func send_death(reason: String) -> void:
	if client == null or not has_connection():
		return
	client.sendDeath(reason)

func has_checked_location(location_id: int) -> bool:
	return client != null and client._checked_locations.has(location_id)

func _connect_client_signals() -> void:
	if not client.slot_data_retrieved.is_connected(_on_slot_data_retrieved):
		client.slot_data_retrieved.connect(_on_slot_data_retrieved)
	if not client.location_scout_retrieved.is_connected(_on_location_scout_retrieved):
		client.location_scout_retrieved.connect(_on_location_scout_retrieved)
	if not client.could_not_connect.is_connected(_on_connection_failed):
		client.could_not_connect.connect(_on_connection_failed)
	if not client.packetConnected.is_connected(_on_packet_connected):
		client.packetConnected.connect(_on_packet_connected)
	if not client.client_connected.is_connected(_on_client_connected):
		client.client_connected.connect(_on_client_connected)
	if not client.client_disconnected.is_connected(_on_client_disconnected):
		client.client_disconnected.connect(_on_client_disconnected)
	if not client.item_received.is_connected(_on_item_received):
		client.item_received.connect(_on_item_received)
	if not client.onDeathFound.is_connected(_on_death_link_received):
		client.onDeathFound.connect(_on_death_link_received)
	if not client.connect_status.is_connected(_on_connect_status):
		client.connect_status.connect(_on_connect_status)
	if not client.connectedWithRoomInfo.is_connected(_on_connected_with_room_info):
		client.connectedWithRoomInfo.connect(_on_connected_with_room_info)
	if not client.logInformations.is_connected(_on_connection_log):
		client.logInformations.connect(_on_connection_log)

func _on_slot_data_retrieved(raw_slot_data: Dictionary) -> void:
	status = STATUS.CONNECTED
	slot_data_received.emit(raw_slot_data)
	process_pending_checks()

func _on_location_scout_retrieved(network_items: Array) -> void:
	scout_received.emit(network_items)

func _on_item_received(item_id: int, received_index: int) -> void:
	item_received.emit(item_id, received_index)

func _on_death_link_received() -> void:
	death_link_received.emit()

func _on_connect_status(message: String) -> void:
	connect_status.emit(message)

func _on_connected_with_room_info() -> void:
	connected_with_room_info.emit()

func _on_connection_log(text: String) -> void:
	log_informations.emit(text)

func _on_connection_failed(message: String) -> void:
	_set_disconnected()
	connection_failed.emit(message)

func _on_packet_connected() -> void:
	packet_connected.emit()
	process_pending_checks()

func _on_client_connected(message: String) -> void:
	client_connected.emit(message)

func _on_client_disconnected() -> void:
	_set_disconnected()

func _set_disconnected() -> void:
	if status == STATUS.DISCONNECTED:
		return
	status = STATUS.DISCONNECTED
	client_disconnected.emit()

