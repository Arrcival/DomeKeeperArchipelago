class_name ArchipelagoItemProcessor

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
	progression.trap_received.connect(_on_progression_trap_received)

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
	if progression.process_item(item_id):
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
		if progression.is_immediate_item(item_id):
			pending_items.erase(item_id)
			process_item(item_id)

func check_upgrades() -> Array[String]:
	var processed_items: Array[String] = []
	while not pending_items.is_empty():
		var processed_item: String = process_item(pending_items.pop_front())
		processed_items.append(processed_item)
	return processed_items

func _on_progression_trap_received() -> void:
	trap_received.emit()

func _take_upgrade(item_id: int) -> String:
	if not upgrade_pools.has(item_id):
		return ""

	var pool: Array = upgrade_pools[item_id]
	if pool.is_empty():
		return ""

	var item_name: String = pool.pop_front()
	upgrade_pools[item_id] = pool
	return item_name
