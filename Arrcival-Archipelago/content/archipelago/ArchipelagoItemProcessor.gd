class_name ArchipelagoItemProcessor

const ITEM_FIRST_ASSIGNMENT_ID: int = 4242200
const ASSIGNMENT_UNLOCK_COUNT: int = 25

var progression: ArchipelagoProgression
var slot_data: ArchipelagoSlotData
var pending_items: Array[int] = []
var received_items: Array[int] = []
var upgrade_pools: Dictionary = {}
var upgrades_bought: Array[String] = []

signal trap_received
signal upgrade_received(item_name: String)

func setup(
	progression_manager: ArchipelagoProgression,
	slot_data_manager: ArchipelagoSlotData
) -> void:
	progression = progression_manager
	slot_data = slot_data_manager

func reset_pending() -> void:
	pending_items.clear()

func reset_upgrades() -> void:
	upgrades_bought.clear()

func receive_item(item_id: int) -> void:
	received_items.append(item_id)
	pending_items.append(item_id)
	process_unlocks()

func prepare_received_items() -> void:
	pending_items = received_items.duplicate()

func set_upgrade_pools(pools: Dictionary) -> void:
	upgrade_pools = pools

# Compatibility wrapper for existing callers.
func item_found(item_id: int) -> void:
	receive_item(item_id)

func process_item(item_id: int) -> String:
	match item_id:
		4242230:
			progression.ironRetrievedGA += 1
			return ""
		4242231:
			progression.waterRetrievedGA += 1
			return ""
		4242232:
			progression.cobaltRetrievedGA += 1
			return ""
		4242233:
			progression.miningStrengthRetrievedGA += 1
			return ""
		4242234:
			progression.movementSpeedRetrievedGA += 1
			return ""
		4242090:
			progression.cobaltRetrieved += 1
			return ""
		4242091:
			progression.waterRetrieved += 1
			return ""
		4242092:
			progression.ironRetrieved += 1
			return ""
		4242095:
			trap_received.emit()
			return ""
		4242100:
			progression.update_colored_layers(slot_data.get_layer_unlock_count())
			return ""

	if item_id >= ITEM_FIRST_ASSIGNMENT_ID and item_id < ITEM_FIRST_ASSIGNMENT_ID + ASSIGNMENT_UNLOCK_COUNT:
		progression.receive_unlock(item_id)
		return ""

	var item_name: String = _take_upgrade(item_id)
	if item_name.is_empty():
		return ""

	upgrades_bought.append(item_name)
	upgrade_received.emit(item_name)
	return item_name

func process_unlocks() -> void:
	var items_to_process: Array[int] = pending_items.duplicate()
	for item_id: int in items_to_process:
		if item_id >= ITEM_FIRST_ASSIGNMENT_ID and item_id < ITEM_FIRST_ASSIGNMENT_ID + ASSIGNMENT_UNLOCK_COUNT:
			pending_items.erase(item_id)
			process_item(item_id)

func check_upgrades() -> Array[String]:
	var processed_items: Array[String] = []
	while not pending_items.is_empty():
		var processed_item: String = process_item(pending_items.pop_front())
		processed_items.append(processed_item)
	return processed_items

func _take_upgrade(item_id: int) -> String:
	if not upgrade_pools.has(item_id):
		return ""

	var pool: Array = upgrade_pools[item_id]
	if pool.is_empty():
		return ""

	var item_name: String = pool.pop_front()
	upgrade_pools[item_id] = pool
	return item_name
