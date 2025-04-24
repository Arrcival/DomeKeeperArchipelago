class_name ArchipelagoData

# To compute back on new game
var cobaltRetrieved: int = 0
var cobaltGiven: int = 0
var waterRetrieved: int = 0
var waterGiven: int = 0
var ironRetrieved: int = 0
var ironGiven: int = 0
var itemsIdFound: Array[int] = []
var itemsFoundToProcess: Array[int] = []

var cobaltRetrievedGA: int = 0
var cobaltGivenGA: int = 0
var waterRetrievedGA: int = 0
var waterGivenGA: int = 0
var ironRetrievedGA: int = 0
var ironGivenGA: int = 0

var switchesFoundIndexes: Array[int] = [] 

# Array of Array of Vector2
var switchesLocation: Array = []

# websocket client
var client

var upgradesBought: Array = []

var locationIds: Dictionary = {
	"archipelagoupgradeiron1": 4243001,
	"archipelagoupgradeiron2": 4243002,
	"archipelagoupgradeiron3": 4243003,
	"archipelagoupgradeiron4": 4243004,
	"archipelagoupgradewater1": 4243005,
	"archipelagoupgradewater2": 4243006,
	"archipelagoupgradewater3": 4243007,
	"archipelagoupgradewater4": 4243008,
	"archipelagoupgradeironwater1": 4243009,
	"archipelagoupgradeironwater2": 4243010,
	"archipelagoupgradeironwater3": 4243011,
	"archipelagoupgradeironwater4": 4243012
}

const LOCATION_FIRST_CAVE_ID: int = 4243020
const LOCATION_FIRST_ASSIGNMENT_ID: int = 4243030
const LOCATION_CHALLENGE_FIRST_ASSIGNMENT_ID: int = 4243050
const LOCATION_FIRST_CHAMBER_SYNC_ID: int = 4243070
const LOCATION_FIRST_CHAMBER_ASYNC_ID: int = 4243080

const ITEM_FIRST_ASSIGNMENT_ID := 4242200

var locationIdCave: int = LOCATION_FIRST_CAVE_ID
var locationIdChamberAsync: int = LOCATION_FIRST_CHAMBER_ASYNC_ID
var locationIdChamberSync: int = LOCATION_FIRST_CHAMBER_SYNC_ID

var chambers_generated = 0

var locationScouts: Dictionary = {
	4243001: "",
	4243002: "",
	4243003: "",
	4243004: "",
	4243005: "",
	4243006: "",
	4243007: "",
	4243008: "",
	4243009: "",
	4243010: "",
	4243011: "",
	4243012: "",
}

# Async <ga_id, bool>
var assignmentsUnlocked : Dictionary
var assignmentsChecked : Dictionary

const FIRST_SWITCH_ID := 4243201
const LAYER_OFFSET := 100

const ASSIGNMENTS_AMOUNT := 16

#region upgrades arrays
var upgrades_keeper1_drill: Array[String] = []
var upgrades_keeper1_jetpack: Array[String] = []
var upgrades_keeper1_carry: Array[String] = []

var upgrades_keeper2_movement: Array[String] = []
var upgrades_keeper2_damage: Array[String] = []
var upgrades_keeper2_bundle: Array[String] = []
var upgrades_keeper2_more_spheres: Array[String] = []
var upgrades_keeper2_lifetime: Array[String] = []
var upgrades_keeper2_special: Array[String] = []
var upgrades_keeper2_mining: Array[String] = []

var upgrades_laser_strength: Array[String] = []
var upgrades_laser_speed: Array[String] = []
var upgrades_laser_aimline: Array[String] = []

var upgrades_sword_strength: Array[String] = []
var upgrades_sword_stab: Array[String] = []
var upgrades_sword_aimline: Array[String] = []
var upgrades_sword_reflection: Array[String] = []

var upgrades_artillery_mortar: Array[String] = []
var upgrades_artillery_machinegun: Array[String] = []

var upgrades_tesla_reticlespeed: Array[String] = []
var upgrades_tesla_quickshot: Array[String] = []
var upgrades_tesla_shotpower: Array[String] = []
var upgrades_tesla_autoaim: Array[String] = []
var upgrades_tesla_orb: Array[String] = []

var upgrades_orchard_duration: Array[String] = []
var upgrades_orchard_overcharge: Array[String] = []
var upgrades_orchard_special: Array[String] = []
var upgrades_orchard_speedboost: Array[String] = []
var upgrades_orchard_miningboost: Array[String] = []

var upgrades_shield_strength: Array[String] = []
var upgrades_shield_special: Array[String] = []
var upgrades_shield_overcharge: Array[String] = []

var upgrades_repellent_delay: Array[String] = []
var upgrades_repellent_special: Array[String] = []
var upgrades_repellent_overcharge: Array[String] = []

var upgrades_droneyard_drones: Array[String] = []
var upgrades_droneyard_speed: Array[String] = []
var upgrades_droneyard_special: Array[String] = []
var upgrades_droneyard_overcharge: Array[String] = []
#endregion

# Names like sent to client
var keeper: String = ""
var dome: String = ""
var primaryGadget: String = ""

var slotName: String = ""
var serverName: String = "archipelago.gg"
var password: String = ""

#region slot data
var seedNumber: int = 0
var keeperSlot: int
var domeSlot: int
var domeGadgetSlot: int
var mapSize: int
var difficulty: int
var drillUpgrades: int
var kineticSphereUpgrades: int
var sphereLifetime: int
var dronesAmount: int
var progressionType: int
var switchesPerLayers: Array = []
var miningEverything: bool
var startingGuildAssignment: int
var challengeMode: bool
var assignmentsAmount: int
var death_link = false
#endregion

var coloredLayersUnlocked: int = 0
var everyLayersUnlockFound: bool = false
var current_assignment: String = ""

var died_to_death_link: bool = false

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

enum CONNECTION_STATUS { DISCONNECTED = 0, IN_PROGRESS = 1, CONNECTED = 2 }

var connection: CONNECTION_STATUS = CONNECTION_STATUS.DISCONNECTED

signal logInformations(text: String)
signal ga_unlocked(id: int)
signal slot_data_have_been_retrieved
signal client_connected
signal client_disconnected

signal trap_received

func connectClient():
	reset()
	resetClient()
	client.slot_data_retrieved.connect(self.retrieveSlotData)
	client.location_scout_retrieved.connect(self.retrieveScout)
	client.could_not_connect.connect(self.connection_failed)
	client.packetConnected.connect(self.connected)
	client.client_connected.connect(self.on_client_connected)
	client.client_disconnected.connect(self.on_client_disconnected)
	client.connectToServer(serverName, slotName, password)
	connection = CONNECTION_STATUS.IN_PROGRESS

func disconnect_client():
	connection = CONNECTION_STATUS.DISCONNECTED
	client.disconnect_from_ap()
	client = null
	
func is_client_connected() -> bool:
	return connection == CONNECTION_STATUS.CONNECTED

func connection_failed(message: String):
	client_disconnected.emit()
	connection = CONNECTION_STATUS.DISCONNECTED

func on_client_connected(message: String):
	client_connected.emit()

func on_client_disconnected():
	connection = CONNECTION_STATUS.DISCONNECTED
	client_disconnected.emit()
	
func resetClient():
	upgradesBought.clear()

func retrieveSlotData(slot_data):
	if slot_data.has("seed"):
		seedNumber = int(slot_data["seed"])
	if slot_data.has("keeper"):
		keeperSlot = slot_data["keeper"]
	if slot_data.has("dome"):
		domeSlot = slot_data["dome"]
	if slot_data.has("domeGadget"):
		domeGadgetSlot = slot_data["domeGadget"]
	if slot_data.has("mapSize"):
		mapSize = slot_data["mapSize"]
	if slot_data.has("difficulty"):
		difficulty = slot_data["difficulty"]
	if slot_data.has("switchesPerLayers"):
		switchesPerLayers = slot_data["switchesPerLayers"]
	if slot_data.has("drillUpgrades"):
		drillUpgrades = slot_data["drillUpgrades"]
	if slot_data.has("kineticSpheres"):
		kineticSphereUpgrades = slot_data["kineticSpheres"]
	if slot_data.has("sphereLifetime"):
		sphereLifetime = slot_data["sphereLifetime"]
	if slot_data.has("dronesAmount"):
		dronesAmount = slot_data["dronesAmount"]
	if slot_data.has("progressionType"):
		progressionType = slot_data["progressionType"]
	if slot_data.has("miningEverything"):
		miningEverything = bool(slot_data["miningEverything"])
	if slot_data.has("startingGA"):
		startingGuildAssignment = slot_data["startingGA"]
		_received_unlock(ITEM_FIRST_ASSIGNMENT_ID + startingGuildAssignment)
	if slot_data.has("challengeMode"):
		challengeMode = bool(slot_data["challengeMode"])
	if slot_data.has("assignmentsAmount"):
		assignmentsAmount = slot_data["assignmentsAmount"] 
	else:
		assignmentsAmount = 16 #backwards compatibility
	slot_data_have_been_retrieved.emit()
	connection = CONNECTION_STATUS.CONNECTED

func submitSwitch(switchPos: Vector2i) -> void:
	for i in range(len(switchesLocation)):
		var layerSwitches: Array[Vector2i]
		layerSwitches.assign(switchesLocation[i])
		var index = layerSwitches.find(switchPos)
		if index != -1:
			var switchId: int = FIRST_SWITCH_ID + (i * LAYER_OFFSET) + index
			switchesFoundIndexes.append(switchId)
			sendCheck(switchId)

func submitUpgrade(upgradeName) -> void:
	var locationId = locationIds.get(upgradeName)
	if locationId != null:
		sendCheck(locationId)

func sendCheck(locationId: int):
	client.sendLocation(locationId)

func reset():
	cobaltRetrieved = 0
	cobaltGiven = 0
	waterRetrieved = 0
	waterGiven = 0
	ironRetrieved = 0
	ironGiven = 0
	cobaltRetrievedGA = 0
	cobaltGivenGA = 0
	waterRetrievedGA = 0
	waterGivenGA = 0
	ironRetrievedGA = 0
	ironGivenGA = 0
	
	coloredLayersUnlocked = 0
	locationIdCave = LOCATION_FIRST_CAVE_ID
	locationIdChamberAsync = LOCATION_FIRST_CHAMBER_ASYNC_ID
	locationIdChamberSync = LOCATION_FIRST_CHAMBER_SYNC_ID
	chambers_generated = 0
	
	assignmentsUnlocked = CONSTARRC.ASSIGNMENTS_DEFAULT_EMPTY.duplicate()
	assignmentsChecked = CONSTARRC.ASSIGNMENTS_DEFAULT_EMPTY.duplicate()

#region generate upgrades
func generateUpgrades():
	reset()
	itemsFoundToProcess = itemsIdFound.duplicate()
	
	upgrades_keeper1_drill = getKeeper1Drills()
	upgrades_keeper1_jetpack = CONSTARRC.KEEPER1_JETPACK.duplicate()
	upgrades_keeper1_carry = CONSTARRC.KEEPER1_CARRY.duplicate()
	
	upgrades_keeper2_movement = CONSTARRC.KEEPER2_MOVEMENT.duplicate()
	upgrades_keeper2_damage = getKeeper2Spheres()
	upgrades_keeper2_bundle = CONSTARRC.KEEPER2_BUNDLE.duplicate()
	upgrades_keeper2_more_spheres = CONSTARRC.KEEPER2_MORESPHERES.duplicate()
	upgrades_keeper2_lifetime = getSphereLifetime()
	upgrades_keeper2_mining = CONSTARRC.KEEPER2_MINING.duplicate()
	upgrades_keeper2_special = pickRandom(CONSTARRC.KEEPER2_SPECIAL_CHOICES)
	
	upgrades_laser_strength = CONSTARRC.LASER_STRENGTH.duplicate() + pickAllRandom(CONSTARRC.LASER_STRENGTH_ROLL) + CONSTARRC.LASER_STRENGTH_AFTER_ROLL.duplicate()
	upgrades_laser_speed = CONSTARRC.LASER_SPEED.duplicate() + pickAllRandom(CONSTARRC.LASER_SPEED_ROLL) + CONSTARRC.LASER_SPEED_AFTER_ROLL.duplicate()
	upgrades_laser_aimline = CONSTARRC.LASER_AIMLINE.duplicate()
	upgrades_sword_strength = CONSTARRC.SWORD_STRENGTH.duplicate() + pickRandom(CONSTARRC.SWORD_STRENGTH_CHOICES)
	upgrades_sword_stab = pickRandom(CONSTARRC.SWORD_STAB_CHOICES)
	upgrades_sword_aimline = CONSTARRC.SWORD_AIMLINE.duplicate()
	upgrades_sword_reflection = CONSTARRC.SWORD_REFLECTION.duplicate() + pickAllRandom(CONSTARRC.SWORD_REFLECTION_ROLL_1) + pickAllRandom(CONSTARRC.SWORD_REFLECTION_ROLL_2)
	
	upgrades_artillery_mortar = pickRandom(CONSTARRC.ARTILLERY_MORTAR_HIT_CHOICES) + CONSTARRC.ARTILLERY_ROTATION + pickRandom(CONSTARRC.ARTILLERY_END_CHOICES)
	upgrades_artillery_machinegun = CONSTARRC.ARTILLERY_MACHINEGUN.duplicate() + pickRandom(CONSTARRC.ARTILLERY_MACHINEGUN_CHOICES)
	
	upgrades_tesla_reticlespeed = CONSTARRC.TESLA_RETICLESPEED.duplicate()
	upgrades_tesla_quickshot = CONSTARRC.TESLA_QUICKSHOT.duplicate()
	upgrades_tesla_shotpower = CONSTARRC.TESLA_SHOTPOWER.duplicate() + pickAllRandom(CONSTARRC.TESLA_SHOTPOWER_ROLL1) + pickAllRandom(CONSTARRC.TESLA_SHOTPOWER_ROLL2)
	upgrades_tesla_autoaim = CONSTARRC.TESLA_AUTOAIM.duplicate()
	upgrades_tesla_orb = CONSTARRC.TESLA_ORB_DEFAULT + pickAllRandom(CONSTARRC.TESLA_ORB_ROLL1) + pickAllRandom(CONSTARRC.TESLA_ORB_ROLL2) + pickAllRandom(CONSTARRC.TESLA_ORB_ROLL3)

	upgrades_orchard_duration = CONSTARRC.ORCHARD_DURATION.duplicate()
	upgrades_orchard_overcharge = CONSTARRC.ORCHARD_OVERCHARGE.duplicate()
	upgrades_orchard_special = pickRandom(CONSTARRC.ORCHARD_SPECIAL_CHOICE)
	upgrades_orchard_speedboost = CONSTARRC.ORCHARD_SPEEDBOOST.duplicate()
	upgrades_orchard_miningboost = CONSTARRC.ORCHARD_MININGBOOST.duplicate()

	upgrades_shield_strength = CONSTARRC.SHIELD_STRENGTH.duplicate()
	upgrades_shield_special = pickRandom(CONSTARRC.SHIELD_SPECIAL_CHOICE)
	upgrades_shield_overcharge = CONSTARRC.SHIELD_OVERCHARGE.duplicate() + pickAllRandom(CONSTARRC.SHIELD_OVERCHARGE_ROLL1) + pickAllRandom(CONSTARRC.SHIELD_OVERCHARGE_ROLL2)
	
	upgrades_repellent_delay = CONSTARRC.REPELLENT_DELAY.duplicate()
	upgrades_repellent_special = pickRandom(CONSTARRC.REPELLENT_SPECIAL_CHOICE)
	if upgrades_repellent_special.has("repellentbattleslowdown"):
		upgrades_repellent_special += pickRandom(CONSTARRC.REPELLENT_DEBILITATE_CHOICE)
	upgrades_repellent_overcharge = CONSTARRC.REPELLENT_OVERCHARGE.duplicate() + pickAllRandom(CONSTARRC.REPELLENT_OVERCHARGE_ROLL1) + pickAllRandom(CONSTARRC.REPELLENT_OVERCHARGE_ROLL2)

	upgrades_droneyard_drones = getDroneyardDrones()
	upgrades_droneyard_speed = CONSTARRC.DRONEYARD_SPEED.duplicate()
	upgrades_droneyard_special = pickRandom(CONSTARRC.DRONEYARD_SPECIAL_CHOICE)
	upgrades_droneyard_overcharge = CONSTARRC.DRONEYARD_OVERCHARGE.duplicate()

func getSphereLifetime() -> Array[String]:
	var upgrade = CONSTARRC.KEEPER2_LIFETIME_NAME
	var rtr: Array[String] = []
	for i in range(sphereLifetime):
		rtr.append(upgrade)
	return rtr

func getKeeper1Drills() -> Array[String]:
	var rtr: Array[String] = CONSTARRC.KEEPER1_DRILL.duplicate()
	for i in range(3, drillUpgrades):
		rtr.append("player1.drill4")
	return rtr
	
func getKeeper2Spheres() -> Array[String]:
	var rtr: Array[String] = CONSTARRC.KEEPER2_DAMAGE.duplicate()
	for i in range(3, kineticSphereUpgrades):
		rtr.append("player1.keeper2pinballdamage4")
	return rtr
	
func getDroneyardDrones() -> Array[String]:
	var rtr: Array[String] = []
	for i in range(kineticSphereUpgrades):
		rtr.append(CONSTARRC.DRONEYARD_DRONES_NAME)
	return rtr
#endregion

func item_found(itemId: int):
	itemsFoundToProcess.append(itemId)
	processUnlocks()

func processItem(itemId: int) -> String:
	var itemName: String = ""

	#region GA items
	if itemId == 4242220:
		ironRetrievedGA += 1
		return ""
	if itemId == 4242221:
		waterRetrievedGA += 1
		return ""
	if itemId == 4242222:
		cobaltRetrievedGA += 1
		return ""

	if itemId >= 4242200 and itemId <= 4242215:
		_received_unlock(itemId)
		return ""
	#endregion

	match itemId:
		4242090:
			cobaltRetrieved += 1
			return ""
		4242091:
			waterRetrieved += 1
			return ""
		4242092:
			ironRetrieved += 1
			return ""
		4242095:
			trap_received.emit()
			return ""
		4242000:
			itemName = _getItemNameAndRemove(upgrades_keeper1_drill)
		4242001:
			itemName = _getItemNameAndRemove(upgrades_keeper1_jetpack)
		4242002:
			itemName = _getItemNameAndRemove(upgrades_keeper1_carry)
		4242010:
			itemName = _getItemNameAndRemove(upgrades_keeper2_movement)
		4242011:
			itemName = _getItemNameAndRemove(upgrades_keeper2_damage)
		4242012:
			itemName = _getItemNameAndRemove(upgrades_keeper2_bundle)
		4242013:
			itemName = _getItemNameAndRemove(upgrades_keeper2_more_spheres)
		4242014:
			itemName = _getItemNameAndRemove(upgrades_keeper2_lifetime)
		4242015:
			itemName = _getItemNameAndRemove(upgrades_keeper2_special)
		4242016:
			itemName = _getItemNameAndRemove(upgrades_keeper2_mining)
		4242020:
			itemName = _getItemNameAndRemove(upgrades_laser_strength)
		4242021:
			itemName = _getItemNameAndRemove(upgrades_laser_speed)
		4242022:
			itemName = _getItemNameAndRemove(upgrades_laser_aimline)
		4242030:
			itemName = _getItemNameAndRemove(upgrades_sword_strength)
		4242031:
			itemName = _getItemNameAndRemove(upgrades_sword_aimline)
		4242032:
			itemName = _getItemNameAndRemove(upgrades_sword_stab)
		4242033:
			itemName = _getItemNameAndRemove(upgrades_sword_reflection)
		4242040:
			itemName = _getItemNameAndRemove(upgrades_artillery_mortar)
		4242041:
			itemName = _getItemNameAndRemove(upgrades_artillery_machinegun)
		4242050:
			itemName = _getItemNameAndRemove(upgrades_tesla_reticlespeed)
		4242051:
			itemName = _getItemNameAndRemove(upgrades_tesla_quickshot)
		4242052:
			itemName = _getItemNameAndRemove(upgrades_tesla_shotpower)
		4242053:
			itemName = _getItemNameAndRemove(upgrades_tesla_autoaim)
		4242054:
			itemName = _getItemNameAndRemove(upgrades_tesla_orb)
		4242060:
			itemName = _getItemNameAndRemove(upgrades_repellent_delay)
		4242061:
			itemName = _getItemNameAndRemove(upgrades_repellent_special)
		4242062:
			itemName = _getItemNameAndRemove(upgrades_repellent_overcharge)
		4242070:
			itemName = _getItemNameAndRemove(upgrades_shield_strength)
		4242071:
			itemName = _getItemNameAndRemove(upgrades_shield_special)
		4242072:
			itemName = _getItemNameAndRemove(upgrades_shield_overcharge)
		4242080:
			itemName = _getItemNameAndRemove(upgrades_orchard_duration)
		4242081:
			itemName = _getItemNameAndRemove(upgrades_orchard_overcharge)
		4242082:
			itemName = _getItemNameAndRemove(upgrades_orchard_special)
		4242083:
			itemName = _getItemNameAndRemove(upgrades_orchard_speedboost)
		4242084:
			itemName = _getItemNameAndRemove(upgrades_orchard_miningboost)
		4242085:
			itemName = _getItemNameAndRemove(upgrades_droneyard_drones)
		4242086:
			itemName = _getItemNameAndRemove(upgrades_droneyard_speed)
		4242087:
			itemName = _getItemNameAndRemove(upgrades_droneyard_special)
		4242088:
			itemName = _getItemNameAndRemove(upgrades_droneyard_overcharge)
		4242100:
			_updateColoredLayers()
			
	GameWorld.addUpgrade(itemName)
	return itemName

func connected() -> void:
	if isRHMode():
		return
	for item in client._checked_locations:
		var assignmentId = item - LOCATION_FIRST_ASSIGNMENT_ID
		if assignmentId >= 0 and assignmentId <= 35:
			if not challengeMode and assignmentId <= 15:
				var key = assignmentsChecked.keys()[assignmentId]
				assignmentsChecked[key] = true
			elif challengeMode and assignmentId >= 20 and assignmentId <= 35:
				var newId = assignmentId - 20
				var key = assignmentsChecked.keys()[newId]
				assignmentsChecked[key] = true
				


func _received_unlock(itemId: int) -> void:
	var id_unlock = itemId - ITEM_FIRST_ASSIGNMENT_ID
	var key = assignmentsUnlocked.keys()[id_unlock]
	assignmentsUnlocked[key] = true
	ga_unlocked.emit(id_unlock)

func get_starting_assignment_name() -> String:
	return assignmentsUnlocked.keys()[startingGuildAssignment]

func _updateColoredLayers() -> void:
	coloredLayersUnlocked += 1
	if mapSize == 0 and coloredLayersUnlocked == 2:
		emit_signal("logInformations", "You also unlocked every layers after the third layer.")
		everyLayersUnlockFound = true
	if mapSize == 1 and coloredLayersUnlocked == 3:
		emit_signal("logInformations", "You also unlocked every layers after the fourth layer.")
		everyLayersUnlockFound = true
	if mapSize == 2 and coloredLayersUnlocked == 5:
		emit_signal("logInformations", "You also unlocked every layers after the sixth layer.")
		everyLayersUnlockFound = true
	if mapSize == 3 and coloredLayersUnlocked == 6:
		emit_signal("logInformations", "You also unlocked every layers after the seventh layer.")
		everyLayersUnlockFound = true

func _getItemNameAndRemove(array: Array) -> String:
	if array.size() > 0:
		var returnedValue = array[0]
		array.remove_at(0)
		return returnedValue
	return ""

func processUnlocks() -> void:
	var itemsToProcess: Array[int] = itemsFoundToProcess.duplicate()
	for i in len(itemsToProcess):
		var item = itemsToProcess[i]
		if item >= 4242200 and item <= 4242215:
			itemsFoundToProcess.erase(item)
			processItem(item)

func checkUpgrades() -> Array:
	var rtr: Array = []
	while itemsFoundToProcess.size() > 0:
		var processedItem = processItem(itemsFoundToProcess[0])
		itemsFoundToProcess.remove_at(0)
		rtr.append(processedItem)
	return rtr

func pickAllRandom(array: Array[String]) -> Array[String]:
	var curArray: Array[String] = array.duplicate(true)
	
	var result: Array[String] = []
	var rng = RandomNumberGenerator.new()
	rng.seed = seedNumber
	while curArray.size() > 0:
		var rand_index:int = rng.randi() % curArray.size()
		result.append(curArray[rand_index])
		curArray.pop_at(rand_index)
	return result

func pickRandom(arrayOfArray: Array) -> Array[String]:
	var rng = RandomNumberGenerator.new()
	rng.seed = seedNumber
	var rand_index:int = rng.randi() % arrayOfArray.size()
	var pickedArray: Array = arrayOfArray[rand_index].duplicate()
	var assignedArray: Array[String]
	assignedArray.assign(pickedArray)
	return assignedArray

func hasLayerUnlocked(layerId: int) -> bool:
	if progressionType != 1:
		return true

	if everyLayersUnlockFound:
		return true
	return layerId <= coloredLayersUnlocked

func isRHMode() -> bool:
	return progressionType == 0 or progressionType == 1

func hasLocationChecked(locationId: int, upgradeName: String) -> bool:
	var hasUpgrade: bool = upgradesBought.has(upgradeName)
	var hasChecked: bool = client._checked_locations.has(locationId)
	return hasUpgrade or hasChecked

func retrieveScout(networkItems: Array) -> void:
	for item in networkItems:
		if locationScouts.keys().has(item.locationId):
			locationScouts[item.locationId] = item.displayUnlock()

func scoutUpgrades():
	client.sendScout(locationScouts.keys(), 0)

func isGAUnlocked(assignment_name: String) -> bool:
	if assignmentsUnlocked.has(assignment_name):
		return assignmentsUnlocked[assignment_name]
	return false

func isGADone(assignment_name: String) -> bool:
	if assignmentsChecked.has(assignment_name):
		return assignmentsChecked[assignment_name]
	return false
	
func getLocationCaveId():
	var rtr: int = locationIdCave
	locationIdCave += 1
	return rtr

func getLocationChamberId(assignment: String = "showdown"):
	if isRHMode():
		var rtr: int = locationIdChamberSync
		locationIdChamberSync += 1
		return rtr
	else:
		locationIdChamberAsync = LOCATION_FIRST_CHAMBER_ASYNC_ID + get_assignment_id(assignment)
		var rtr = locationIdChamberAsync + chambers_generated * ASSIGNMENTS_AMOUNT
		chambers_generated += 1
		return rtr

func is_async_won():
	var wonAssignments = 0
	for value in assignmentsChecked.values():
		if value == true:
			wonAssignments += 1

	return wonAssignments >= assignmentsAmount

func ga_completion(assignment_name: String, isChallengeMode: bool) -> void:
	var assignmentId: int = assignmentsChecked.keys().find(assignment_name)
	if assignmentId != -1:
		var locationId: int = LOCATION_FIRST_ASSIGNMENT_ID + assignmentId
		sendCheck(locationId)
		if isChallengeMode:
			var locationChallengeId: int = LOCATION_CHALLENGE_FIRST_ASSIGNMENT_ID + assignmentId
			sendCheck(locationChallengeId)
		if not challengeMode:
			assignmentsChecked[assignment_name] = true
		if challengeMode and isChallengeMode:
			assignmentsChecked[assignment_name] = true
	
	if is_async_won():
		client.completedGoal()

func get_seed(assignment: String = "showdown") -> int:
	if isRHMode():
		return seedNumber
	else:
		return seedNumber + get_assignment_id(assignment)

func get_assignment_id(assignment) -> int:
	var index = CONSTARRC.ASSIGMENTS_LIST.find(assignment)
	if index == -1:
		index = 0
	return index
