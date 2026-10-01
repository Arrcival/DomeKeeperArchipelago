class_name ArchipelagoData

var _progression: ArchipelagoProgression = ArchipelagoProgression.new()
var _item_processor: ArchipelagoItemProcessor = ArchipelagoItemProcessor.new()
var _connection_manager: ArchipelagoConnection = ArchipelagoConnection.new()
var _upgrade_generator: ArchipelagoUpgradeGenerator = ArchipelagoUpgradeGenerator.new()
var _assignment_manager: ArchipelagoAssignmentManager = ArchipelagoAssignmentManager.new()

var _slot_data: ArchipelagoSlotData = ArchipelagoSlotData.new()
var _locations: ArchipelagoLocationManager = ArchipelagoLocationManager.new()

#region slot data

var keeperSlot: int:
	get: return _slot_data.keeperSlot
var domeSlot: int:
	get: return _slot_data.domeSlot
var domeGadgetSlot: int:
	get: return _slot_data.domeGadgetSlot
var mapSize: int:
	get: return _slot_data.mapSize
var difficulty: int:
	get: return _slot_data.difficulty
var switchesPerLayer: Array:
	get: return _slot_data.switchesPerLayer
var miningEverything: bool:
	get: return _slot_data.miningEverything
var challengeMode: bool:
	get: return _slot_data.challengeMode
var assignmentsAmount: int:
	get: return _slot_data.assignmentsAmount
#endregion

var coloredLayersUnlocked: int:
	get: return _progression.relic.coloredLayersUnlocked
	set(value): _progression.relic.coloredLayersUnlocked = value
var everyLayersUnlockFound: bool:
	get: return _progression.relic.everyLayersUnlockFound
	set(value): _progression.relic.everyLayersUnlockFound = value

func _init() -> void:
	_connection_manager.slot_data_received.connect(retrieveSlotData)
	_connection_manager.scout_received.connect(retrieveScout)
	_connection_manager.packet_connected.connect(connected)
	_connection_manager.client_connected.connect(on_client_connected)
	_connection_manager.client_disconnected.connect(on_client_disconnected)
	_connection_manager.item_received.connect(_on_item_received)
	_connection_manager.death_link_received.connect(_on_death_link_received)
	_connection_manager.connect_status.connect(_on_connect_status)
	_connection_manager.connected_with_room_info.connect(_on_connected_with_room_info)
	_connection_manager.log_informations.connect(_on_connection_log)
	_connection_manager.connection_failed.connect(connection_failed)

	_progression.setup(_slot_data)
	_progression.log_informations.connect(_on_progression_log)
	_assignment_manager.setup(_progression.guild, _slot_data, Callable(self, "sendCheck"))
	_upgrade_generator.setup(_slot_data)
	_item_processor.setup(_progression, _slot_data)
	_item_processor.trap_received.connect(_on_item_trap_received)
	_item_processor.upgrade_received.connect(_on_upgrade_received)

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
	_connection_manager.client = value

# Starts a connection without changing the current run state.
# This is used by the pause menu after a transient disconnection.
func connect_client() -> void:
	_connection_manager.connect_client()

# Disconnects while preserving _progression, received items, and _locations.
func disconnect_client() -> void:
	_connection_manager.disconnect_client()

# Starts a completely new Archipelago session from the title screen.
func connect_new_session() -> void:
	reset_all_state()
	_connection_manager.reset_received_item_history()
	_connection_manager.connect_client()

# Disconnects and removes all Archipelago state from the previous session.
func disconnect_client_and_reset() -> void:
	_connection_manager.disconnect_client()
	reset_all_state()
	_connection_manager.reset_received_item_history()

func reset_all_state() -> void:
	_connection_manager.clear_pending_checks()
	_slot_data.reset()
	_progression.reset()
	_locations.reset_all()
	_item_processor.reset_all()

func is_client_connected() -> bool:
	return _connection_manager.has_connection()

func is_connection_disconnected() -> bool:
	return _connection_manager.is_disconnected()

func get_server_name() -> String:
	return _connection_manager.get_server_name()

func connection_failed(message: String) -> void:
	could_not_connect.emit(message)

func on_client_connected(message: String) -> void:
	client_connected.emit(message)

func on_client_disconnected() -> void:
	client_disconnected.emit()
	
func _on_item_received(item_id: int, received_index: int) -> void:
	_item_processor.receive_item(item_id, received_index)
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
	_item_processor.reset_upgrades()

func retrieveSlotData(raw_slot_data: Dictionary) -> void:
	_slot_data.apply(raw_slot_data)
	if raw_slot_data.has("startingGA"):
		_assignment_manager.receive_starting_assignment(_slot_data.startingGuildAssignment)
	slot_data_have_been_retrieved.emit()

func submitSwitch(switchPos: Vector2i) -> void:
	var switch_id :int = _locations.get_switch_location(switchPos)
	if switch_id != -1:
		sendCheck(switch_id)

func submitUpgrade(upgradeName: String) -> void:
	var location_id :int = _locations.get_upgrade_location(upgradeName)
	if location_id != -1:
		sendCheck(location_id)

func get_upgrade_description(upgrade_name: String) -> String:
	var location_id := _locations.get_upgrade_location(upgrade_name)
	if location_id == -1:
		return ""
	if _connection_manager.has_checked_location(location_id):
		return "Location already checked!"
	return _locations.get_scout_description(location_id)

func sendCheck(locationId: int) -> void:
	_connection_manager.queue_location_check(locationId)

func send_death(reason: String) -> void:
	_connection_manager.send_death(reason)

func mark_death_link_death() -> void:
	_progression.mark_death_link_death()

func consume_death_link_death() -> bool:
	return _progression.consume_death_link_death()

func reset_given_resources() -> void:
	_progression.reset_given_resources()

func consume_resource_deltas() -> Dictionary:
	return _progression.consume_resource_deltas()

func get_switches_per_layer() -> Array:
	return _slot_data.switchesPerLayer.duplicate()

func clear_switch_locations() -> void:
	_locations.switches_location.clear()

func add_switch_locations(layer_locations: Array) -> void:
	_locations.switches_location.append(layer_locations)

func prepare_level() -> void:
	generateUpgrades()
	reset_given_resources()

# Resets resource and _progression state for a new game.
func reset_progression() -> void:
	_progression.reset()

# Resets generated location state without changing received item data.
func reset_location_generation() -> void:
	_locations.reset()

# Clears items that have not yet been applied to the game.
func reset_item_processing() -> void:
	_item_processor.reset_pending()

# Resets all transient game state while preserving the received item history.
# This keeps the old reset() API available to existing callers.
func reset() -> void:
	reset_progression()
	reset_location_generation()
	_item_processor.reset_for_new_run()

# Generate deterministic upgrade pools and give them to the item processor.
func generateUpgrades() -> void:
	reset()
	_item_processor.prepare_received_items()
	_item_processor.set_upgrade_pools(_upgrade_generator.generate())

func _on_item_trap_received() -> void:
	trap_received.emit()

func _on_upgrade_received(item_name: String) -> void:
	upgrade_received.emit(item_name)

func receive_item(item_id: int) -> void:
	_item_processor.receive_item(item_id)

# Compatibility wrapper for existing callers.
func item_found(itemId: int) -> void:
	receive_item(itemId)

func connected() -> void:
	if not isRHMode():
		_assignment_manager.process_checked_locations(_connection_manager.get_checked_locations())

func _on_progression_log(text: String) -> void:
	logInformations.emit(text)

func checkUpgrades() -> Array[String]:
	return _item_processor.check_upgrades()

func hasLayerUnlocked(layerId: int) -> bool:
	if not is_relic_hunt_with_colored_layers():
		return true

	if everyLayersUnlockFound:
		return true
	return layerId <= coloredLayersUnlocked

func is_relic_hunt() -> bool:
	return _slot_data.is_relic_hunt()

func is_relic_hunt_with_colored_layers() -> bool:
	return _slot_data.is_relic_hunt_with_colored_layers()

# Compatibility wrapper for existing extensions.
func isRHMode() -> bool:
	return is_relic_hunt() or is_relic_hunt_with_colored_layers()

func retrieveScout(networkItems: Array) -> void:
	_locations.receive_scouts(networkItems)

func scoutUpgrades() -> void:
	_connection_manager.send_scout(_locations.get_scout_location_ids())

func isGAUnlocked(assignment_name: String) -> bool:
	return _assignment_manager.is_unlocked(assignment_name)

func isGADone(assignment_name: String) -> bool:
	return _assignment_manager.is_done(assignment_name)
	
func getLocationCaveId() -> int:
	return _locations.next_cave_location()

func getLocationChamberId(assignment: String = "showdown") -> int:
	return _locations.next_chamber_location(isRHMode(), get_assignment_id(assignment))

func is_async_won() -> bool:
	return _assignment_manager.is_async_won()

func ga_completion(assignment_name: String, isChallengeMode: bool) -> void:
	if _assignment_manager.complete(assignment_name, isChallengeMode):
		_connection_manager.complete_goal()

func get_seed(assignment: String = "showdown") -> int:
	return _slot_data.get_seed(assignment)

func get_assignment_id(assignment: String) -> int:
	return _assignment_manager.get_assignment_id(assignment)

func get_relic_hunt_stats() -> String:
	return _progression.get_relic_hunt_stats()

func complete_relichunt() -> void:
	_connection_manager.complete_goal()

func get_relic_hunt_slot_data() -> Dictionary:
	return _slot_data.get_relic_hunt_slot_data()

func get_starting_assignment_name() -> String:
	return _slot_data.get_starting_assignment_name()