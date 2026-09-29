class_name ArchipelagoAssignmentManager

const CONSTARRC: GDScript = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")
const ITEM_FIRST_ASSIGNMENT_ID: int = 4242200
const LOCATION_FIRST_ASSIGNMENT_ID: int = 4243030
const ASSIGNMENTS_AMOUNT: int = 25

var assignments_unlocked: Dictionary = {}
var assignments_checked: Dictionary = {}

signal assignment_unlocked(id: int)

func reset() -> void:
	assignments_unlocked = CONSTARRC.ASSIGNMENTS_DEFAULT_EMPTY.duplicate()
	assignments_checked = CONSTARRC.ASSIGNMENTS_DEFAULT_EMPTY.duplicate()

func receive_unlock(item_id: int) -> void:
	var unlock_id: int = item_id - ITEM_FIRST_ASSIGNMENT_ID
	if unlock_id < 0 or unlock_id >= CONSTARRC.ASSIGNMENTS_LIST.size():
		push_warning("Invalid assignment unlock item ID: %s" % item_id)
		return

	var assignment_name: String = CONSTARRC.ASSIGNMENTS_LIST[unlock_id]
	assignments_unlocked[assignment_name] = true
	assignment_unlocked.emit(unlock_id)

func mark_checked(assignment_name: String) -> void:
	if assignments_checked.has(assignment_name):
		assignments_checked[assignment_name] = true

func apply_checked_locations(location_ids: Array, challenge_mode: bool) -> void:
	for location_id: int in location_ids:
		var assignment_id: int = location_id - LOCATION_FIRST_ASSIGNMENT_ID
		if not challenge_mode and assignment_id >= 0 and assignment_id < ASSIGNMENTS_AMOUNT:
			mark_checked(CONSTARRC.ASSIGNMENTS_LIST[assignment_id])
		elif challenge_mode and assignment_id >= ASSIGNMENTS_AMOUNT and assignment_id < ASSIGNMENTS_AMOUNT * 2:
			var challenge_id: int = assignment_id - ASSIGNMENTS_AMOUNT
			mark_checked(CONSTARRC.ASSIGNMENTS_LIST[challenge_id])

func is_unlocked(assignment_name: String) -> bool:
	return assignments_unlocked.get(assignment_name, false)

func is_done(assignment_name: String) -> bool:
	return assignments_checked.get(assignment_name, false)

func is_async_won(assignments_amount: int) -> bool:
	var won_assignments: int = 0
	for value: Variant in assignments_checked.values():
		if value == true:
			won_assignments += 1
	return won_assignments >= assignments_amount

func get_starting_assignment_name(starting_assignment: int) -> String:
	if starting_assignment < 0 or starting_assignment >= CONSTARRC.ASSIGNMENTS_LIST.size():
		push_warning("Invalid starting assignment ID: %s" % starting_assignment)
		return ""
	return CONSTARRC.ASSIGNMENTS_LIST[starting_assignment]
