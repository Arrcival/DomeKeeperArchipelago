class_name ArchipelagoData

var progression: ArchipelagoProgression = ArchipelagoProgression.new()
var item_processor: ArchipelagoItemProcessor = ArchipelagoItemProcessor.new()
var connection_manager: ArchipelagoConnection = ArchipelagoConnection.new()
var upgrade_generator: ArchipelagoUpgradeGenerator = ArchipelagoUpgradeGenerator.new()


# Compatibility views. Item history and pending items are owned by the processor.
var itemsIdFound: Array[int]:
	get: return item_processor.received_items
var itemsFoundToProcess: Array[int]:
	get: return item_processor.pending_items

#region Bonus getter/setters
var cobaltRetrieved: int:
	get: return progression.cobaltRetrieved
	set(value): progression.cobaltRetrieved = value
var cobaltGiven: int:
	get: return progression.cobaltGiven
	set(value): progression.cobaltGiven = value
var waterRetrieved: int:
	get: return progression.waterRetrieved
	set(value): progression.waterRetrieved = value
var waterGiven: int:
	get: return progression.waterGiven
	set(value): progression.waterGiven = value
var ironRetrieved: int:
	get: return progression.ironRetrieved
	set(value): progression.ironRetrieved = value
var ironGiven: int:
	get: return progression.ironGiven
	set(value): progression.ironGiven = value
var cobaltRetrievedGA: int:
	get: return progression.cobaltRetrievedGA
	set(value): progression.cobaltRetrievedGA = value
var cobaltGivenGA: int:
	get: return progression.cobaltGivenGA
	set(value): progression.cobaltGivenGA = value
var waterRetrievedGA: int:
	get: return progression.waterRetrievedGA
	set(value): progression.waterRetrievedGA = value
var waterGivenGA: int:
	get: return progression.waterGivenGA
	set(value): progression.waterGivenGA = value
var ironRetrievedGA: int:
	get: return progression.ironRetrievedGA
	set(value): progression.ironRetrievedGA = value
var ironGivenGA: int:
	get: return progression.ironGivenGA
	set(value): progression.ironGivenGA = value
var miningStrengthRetrievedGA: int:
	get: return progression.miningStrengthRetrievedGA
	set(value): progression.miningStrengthRetrievedGA = value
var miningStrengthGivenGA: int:
	get: return progression.miningStrengthGivenGA
	set(value): progression.miningStrengthGivenGA = value
var movementSpeedRetrievedGA: int:
	get: return progression.movementSpeedRetrievedGA
	set(value): progression.movementSpeedRetrievedGA = value
var movementSpeedGivenGA: int:
	get: return progression.movementSpeedGivenGA
	set(value): progression.movementSpeedGivenGA = value
#endregion

# Compatibility access for existing extensions.
var client: Variant:
	get: return connection_manager.client
	set(value): connection_manager.client = value


# Compatibility view for the upgrades applied by the item processor.
var upgradesBought: Array[String]:
	get: return item_processor.upgrades_bought

const LOCATION_FIRST_ASSIGNMENT_ID: int = 4243030
const LOCATION_CHALLENGE_FIRST_ASSIGNMENT_ID: int = 4243050
const ITEM_FIRST_ASSIGNMENT_ID: int = 4242200

var slotData = ArchipelagoSlotData.new()
var locations: ArchipelagoLocationManager = ArchipelagoLocationManager.new()

const DEFAULT_ASSIGNMENTS_AMOUNT :int = 25

# Compatibility access for existing extensions.
var assignmentsUnlocked: Dictionary:
	get: return progression.assignmentsUnlocked
	set(value): progression.assignmentsUnlocked = value
var assignmentsChecked: Dictionary:
	get: return progression.assignmentsChecked
	set(value): progression.assignmentsChecked = value


const ASSIGNMENTS_AMOUNT := 25

# Names like sent to client
var keeper: String = ""
var dome: String = ""
var primaryGadget: String = ""

# Compatibility access for existing extensions.
var slotName: String:
	get: return connection_manager.slot_name
var serverName: String:
	get: return connection_manager.server_name
var password: String:
	get: return connection_manager.password

#region slot data

# Compatibility properties. Existing extensions can keep reading slot data
# from GameWorld.archipelago while the storage lives in ArchipelagoSlotData.
var seedNumber: int:
	get: return slotData.seedNumber
var keeperSlot: int:
	get: return slotData.keeperSlot
var domeSlot: int:
	get: return slotData.domeSlot
var domeGadgetSlot: int:
	get: return slotData.domeGadgetSlot
var mapSize: int:
	get: return slotData.mapSize
var difficulty: int:
	get: return slotData.difficulty
var drillUpgrades: int:
	get: return slotData.drillUpgrades
var kineticSphereUpgrades: int:
	get: return slotData.kineticSphereUpgrades
var sphereLifetime: int:
	get: return slotData.sphereLifetime
var kunaiUpgrades: int:
	get: return slotData.kunaiUpgrades
var beastmasterMiningUpgrades: int:
	get: return slotData.beastmasterMiningUpgrades
var catgoblinsAmount: int:
	get: return slotData.catgoblinsAmount
var dronesAmount: int:
	get: return slotData.dronesAmount
var progressionType: int:
	get: return slotData.progressionType
var switchesPerLayer: Array:
	get: return slotData.switchesPerLayer
var miningEverything: bool:
	get: return slotData.miningEverything
var startingGuildAssignment: int:
	get: return slotData.startingGuildAssignment
var challengeMode: bool:
	get: return slotData.challengeMode
var assignmentsAmount: int:
	get: return slotData.assignmentsAmount
var death_link: bool:
	get: return slotData.death_link
#endregion

# Compatibility access for map generation and existing extensions.
var switchesFoundIndexes: Array[int]:
	get: return locations.switches_found
var switchesLocation: Array:
	get: return locations.switches_location
var locationScouts: Dictionary:
	get: return locations.location_scouts

var coloredLayersUnlocked: int:
	get: return progression.coloredLayersUnlocked
	set(value): progression.coloredLayersUnlocked = value
var everyLayersUnlockFound: bool:
	get: return progression.everyLayersUnlockFound
	set(value): progression.everyLayersUnlockFound = value
var current_assignment: String:
	get: return progression.current_assignment
	set(value): progression.current_assignment = value
var died_to_death_link: bool:
	get: return progression.died_to_death_link
	set(value): progression.died_to_death_link = value

const CONSTARRC: GDScript = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

enum CONNECTION_STATUS { DISCONNECTED = 0, IN_PROGRESS = 1, CONNECTED = 2 }

# Compatibility view of the connection manager status.
var connection: CONNECTION_STATUS:
	get: return connection_manager.status as CONNECTION_STATUS

func _init() -> void:
	connection_manager.slot_data_received.connect(retrieveSlotData)
	connection_manager.scout_received.connect(retrieveScout)
	connection_manager.packet_connected.connect(connected)
	connection_manager.client_connected.connect(on_client_connected)
	connection_manager.client_disconnected.connect(on_client_disconnected)
	connection_manager.item_received.connect(_on_item_received)
	connection_manager.death_link_received.connect(_on_death_link_received)
	connection_manager.connect_status.connect(_on_connect_status)
	connection_manager.connected_with_room_info.connect(_on_connected_with_room_info)
	connection_manager.log_informations.connect(_on_connection_log)
	connection_manager.connection_failed.connect(connection_failed)

	progression.log_informations.connect(_on_progression_log)
	upgrade_generator.setup(slotData)
	item_processor.setup(progression, slotData)
	item_processor.trap_received.connect(_on_item_trap_received)
	item_processor.upgrade_received.connect(_on_upgrade_received)

signal logInformations(text: String)

signal slot_data_have_been_retrieved
signal client_connected(message: String)
signal client_disconnected
signal onDeathFound
signal connect_status(message: String)
signal connectedWithRoomInfo
signal could_not_connect(message: String)
signal item_received(item_id: int)
signal upgrade_received(item_name: String)

signal trap_received

func set_client(value: Variant) -> void:
	connection_manager.client = value

func connect_client() -> void:
	reset_progression()
	reset_location_generation()
	reset_item_processing()
	reset_client()
	connection_manager.connect_client()

func disconnect_client() -> void:
	connection_manager.disconnect_client()

func is_client_connected() -> bool:
	return connection_manager.has_connection()

func connection_failed(message: String) -> void:
	could_not_connect.emit(message)

func on_client_connected(message: String) -> void:
	client_connected.emit(message)

func on_client_disconnected() -> void:
	client_disconnected.emit()
	
func _on_item_received(item_id: int) -> void:
	item_found(item_id)
	item_received.emit(item_id)

func _on_death_link_received() -> void:
	onDeathFound.emit()

func _on_connect_status(message: String) -> void:
	connect_status.emit(message)

func _on_connected_with_room_info() -> void:
	connectedWithRoomInfo.emit()

func _on_connection_log(text: String) -> void:
	logInformations.emit(text)

func reset_client() -> void:
	item_processor.reset_upgrades()

func retrieveSlotData(raw_slot_data: Dictionary) -> void:
	slotData.apply(raw_slot_data)
	if raw_slot_data.has("startingGA"):
		_received_unlock(ITEM_FIRST_ASSIGNMENT_ID + slotData.startingGuildAssignment)
	slot_data_have_been_retrieved.emit()

func submitSwitch(switchPos: Vector2i) -> void:
	var switch_id :int = locations.get_switch_location(switchPos)
	if switch_id != -1:
		sendCheck(switch_id)

func submitUpgrade(upgradeName: String) -> void:
	var location_id :int = locations.get_upgrade_location(upgradeName)
	if location_id != -1:
		sendCheck(location_id)

func sendCheck(locationId: int) -> void:
	connection_manager.send_check(locationId)

func send_death(reason: String) -> void:
	connection_manager.send_death(reason)

func mark_death_link_death() -> void:
	progression.mark_death_link_death()

func consume_death_link_death() -> bool:
	return progression.consume_death_link_death()

func reset_given_resources() -> void:
	progression.reset_given_resources()

func prepare_level() -> void:
	generateUpgrades()
	reset_given_resources()

# Resets resource and progression state for a new game.
func reset_progression() -> void:
	progression.reset()

# Resets generated location state without changing received item data.
func reset_location_generation() -> void:
	locations.reset()

# Clears items that have not yet been applied to the game.
func reset_item_processing() -> void:
	item_processor.reset_pending()

# Resets all transient game state while preserving the received item history.
# This keeps the old reset() API available to existing callers.
func reset() -> void:
	reset_progression()
	reset_location_generation()
	reset_item_processing()

# Generate deterministic upgrade pools and give them to the item processor.
func generateUpgrades() -> void:
	reset()
	item_processor.prepare_received_items()
	item_processor.set_upgrade_pools(upgrade_generator.generate())

func _on_item_trap_received() -> void:
	trap_received.emit()

func _on_upgrade_received(item_name: String) -> void:
	upgrade_received.emit(item_name)

func receive_item(item_id: int) -> void:
	item_processor.receive_item(item_id)

# Compatibility wrapper for existing callers.
func item_found(itemId: int) -> void:
	receive_item(itemId)

func processItem(itemId: int) -> String:
	return item_processor.process_item(itemId)

func connected() -> void:
	if isRHMode() or client == null:
		return
	for item: int in client._checked_locations:
		var assignmentId: int = item - LOCATION_FIRST_ASSIGNMENT_ID
		if not challengeMode and assignmentId >= 0 and assignmentId < ASSIGNMENTS_AMOUNT:
			var assignment_name: String = CONSTARRC.ASSIGNMENTS_LIST[assignmentId]
			progression.mark_assignment_checked(assignment_name)
		# have to verify
		elif challengeMode and assignmentId >= ASSIGNMENTS_AMOUNT and assignmentId < ASSIGNMENTS_AMOUNT * 2:
			var challenge_id: int = assignmentId - ASSIGNMENTS_AMOUNT
			var assignment_name: String = CONSTARRC.ASSIGNMENTS_LIST[challenge_id]
			progression.mark_assignment_checked(assignment_name)

func _received_unlock(itemId: int) -> void:
	progression.receive_unlock(itemId)




func _on_progression_log(text: String) -> void:
	logInformations.emit(text)

func get_starting_assignment_name() -> String:
	return progression.get_starting_assignment_name(startingGuildAssignment)


func processUnlocks() -> void:
	item_processor.process_unlocks()

func checkUpgrades() -> Array[String]:
	return item_processor.check_upgrades()

func hasLayerUnlocked(layerId: int) -> bool:
	if not is_relic_hunt_with_colored_layers():
		return true

	if everyLayersUnlockFound:
		return true
	return layerId <= coloredLayersUnlocked

func is_relic_hunt() -> bool:
	return slotData.is_relic_hunt()

func is_relic_hunt_with_colored_layers() -> bool:
	return slotData.is_relic_hunt_with_colored_layers()

func is_guild_assignment() -> bool:
	return slotData.is_guild_assignment()

# Compatibility wrapper for existing extensions.
func isRHMode() -> bool:
	return is_relic_hunt() or is_relic_hunt_with_colored_layers()

func hasLocationChecked(locationId: int, upgradeName: String) -> bool:
	var hasUpgrade: bool = upgradesBought.has(upgradeName)
	var hasChecked: bool = connection_manager.has_checked_location(locationId)
	return hasUpgrade or hasChecked

func retrieveScout(networkItems: Array) -> void:
	locations.receive_scouts(networkItems)

func scoutUpgrades() -> void:
	connection_manager.send_scout(locations.get_scout_location_ids())

func isGAUnlocked(assignment_name: String) -> bool:
	return progression.is_assignment_unlocked(assignment_name)

func isGADone(assignment_name: String) -> bool:
	return progression.is_assignment_done(assignment_name)
	
func getLocationCaveId() -> int:
	return locations.next_cave_location()

func getLocationChamberId(assignment: String = "showdown") -> int:
	return locations.next_chamber_location(isRHMode(), get_assignment_id(assignment))

func is_async_won() -> bool:
	return progression.is_async_won(assignmentsAmount)

func ga_completion(assignment_name: String, isChallengeMode: bool) -> void:
	var assignmentId: int = CONSTARRC.ASSIGNMENTS_LIST.find(assignment_name)
	if assignmentId != -1:
		var locationId: int = LOCATION_FIRST_ASSIGNMENT_ID + assignmentId
		sendCheck(locationId)
		if isChallengeMode:
			var locationChallengeId: int = LOCATION_CHALLENGE_FIRST_ASSIGNMENT_ID + assignmentId
			sendCheck(locationChallengeId)
		if not challengeMode:
			progression.mark_assignment_checked(assignment_name)
		if challengeMode and isChallengeMode:
			progression.mark_assignment_checked(assignment_name)
	
	if is_async_won():
		connection_manager.complete_goal()

func get_seed(assignment: String = "showdown") -> int:
	return slotData.get_seed(assignment)

func get_assignment_id(assignment: String) -> int:
	return slotData.get_assignment_id(assignment)

func get_layer_unlock_count() -> int:
	return slotData.get_layer_unlock_count()
