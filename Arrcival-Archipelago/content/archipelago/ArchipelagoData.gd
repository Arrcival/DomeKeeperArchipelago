class_name ArchipelagoData

var progression: ArchipelagoProgression = ArchipelagoProgression.new()
var item_processor: ArchipelagoItemProcessor = ArchipelagoItemProcessor.new()
var connection_manager: ArchipelagoConnection = ArchipelagoConnection.new()
var upgrade_generator: ArchipelagoUpgradeGenerator = ArchipelagoUpgradeGenerator.new()
var assignment_manager: ArchipelagoAssignmentManager = ArchipelagoAssignmentManager.new()

var slotData = ArchipelagoSlotData.new()
var locations: ArchipelagoLocationManager = ArchipelagoLocationManager.new()

#region slot data

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
var switchesPerLayer: Array:
	get: return slotData.switchesPerLayer
var miningEverything: bool:
	get: return slotData.miningEverything
var challengeMode: bool:
	get: return slotData.challengeMode
var assignmentsAmount: int:
	get: return slotData.assignmentsAmount
#endregion

var coloredLayersUnlocked: int:
	get: return progression.relic.coloredLayersUnlocked
	set(value): progression.relic.coloredLayersUnlocked = value
var everyLayersUnlockFound: bool:
	get: return progression.relic.everyLayersUnlockFound
	set(value): progression.relic.everyLayersUnlockFound = value

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

	progression.setup(slotData)
	progression.log_informations.connect(_on_progression_log)
	assignment_manager.setup(progression.guild, slotData, Callable(self, "sendCheck"))
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

func is_connection_disconnected() -> bool:
	return connection_manager.is_disconnected()

func get_server_name() -> String:
	return connection_manager.get_server_name()

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
		assignment_manager.receive_starting_assignment(slotData.startingGuildAssignment)
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

func connected() -> void:
	if isRHMode():
		return
	assignment_manager.process_checked_locations(connection_manager.get_checked_locations())




func _on_progression_log(text: String) -> void:
	logInformations.emit(text)

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

# Compatibility wrapper for existing extensions.
func isRHMode() -> bool:
	return is_relic_hunt() or is_relic_hunt_with_colored_layers()

func retrieveScout(networkItems: Array) -> void:
	locations.receive_scouts(networkItems)

func scoutUpgrades() -> void:
	connection_manager.send_scout(locations.get_scout_location_ids())

func isGAUnlocked(assignment_name: String) -> bool:
	return assignment_manager.is_unlocked(assignment_name)

func isGADone(assignment_name: String) -> bool:
	return assignment_manager.is_done(assignment_name)
	
func getLocationCaveId() -> int:
	return locations.next_cave_location()

func getLocationChamberId(assignment: String = "showdown") -> int:
	return locations.next_chamber_location(isRHMode(), get_assignment_id(assignment))

func is_async_won() -> bool:
	return assignment_manager.is_async_won()

func ga_completion(assignment_name: String, isChallengeMode: bool) -> void:
	if assignment_manager.complete(assignment_name, isChallengeMode):
		connection_manager.complete_goal()

func get_seed(assignment: String = "showdown") -> int:
	return slotData.get_seed(assignment)

func get_assignment_id(assignment: String) -> int:
	return assignment_manager.get_assignment_id(assignment)

