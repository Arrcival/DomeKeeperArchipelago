class_name ArchipelagoAssignmentManager

const CONSTARRC: GDScript = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

const LOCATION_FIRST_ASSIGNMENT_ID: int = 4243030
const LOCATION_CHALLENGE_FIRST_ASSIGNMENT_ID: int = 4243050
const ITEM_FIRST_ASSIGNMENT_ID: int = 4242200
const ASSIGNMENTS_AMOUNT: int = 25

var progression: ArchipelagoAssignmentProgression
var slot_data: ArchipelagoSlotData
var send_check: Callable

func setup(
	assignment_progression: ArchipelagoAssignmentProgression,
	assignment_slot_data: ArchipelagoSlotData,
	check_sender: Callable
) -> void:
	progression = assignment_progression
	slot_data = assignment_slot_data
	send_check = check_sender

func receive_starting_assignment(assignment_id: int) -> void:
	if not slot_data.is_guild_assignment():
		return
	progression.receive_unlock(ITEM_FIRST_ASSIGNMENT_ID + assignment_id)

func process_checked_locations(checked_locations: Array) -> void:
	for location_id: int in checked_locations:
		var assignment_id: int = location_id - LOCATION_FIRST_ASSIGNMENT_ID
		if not slot_data.challengeMode and assignment_id >= 0 and assignment_id < ASSIGNMENTS_AMOUNT:
			_mark_assignment_checked(assignment_id)
		elif slot_data.challengeMode and assignment_id >= ASSIGNMENTS_AMOUNT and assignment_id < ASSIGNMENTS_AMOUNT * 2:
			_mark_assignment_checked(assignment_id - ASSIGNMENTS_AMOUNT)

func _mark_assignment_checked(assignment_id: int) -> void:
	progression.mark_assignment_checked(CONSTARRC.ASSIGNMENTS_LIST[assignment_id])

func is_unlocked(assignment_name: String) -> bool:
	return progression.is_assignment_unlocked(assignment_name)

func is_done(assignment_name: String) -> bool:
	return progression.is_assignment_done(assignment_name)

func get_assignment_id(assignment_name: String) -> int:
	return slot_data.get_assignment_id(assignment_name)

func _find_assignment_id(assignment_name: String) -> int:
	return CONSTARRC.ASSIGNMENTS_LIST.find(assignment_name)

func is_async_won() -> bool:
	return progression.is_async_won(slot_data.assignmentsAmount)

func complete(assignment_name: String, is_challenge: bool) -> bool:
	var assignment_id: int = _find_assignment_id(assignment_name)
	if assignment_id != -1:
		send_check.call(LOCATION_FIRST_ASSIGNMENT_ID + assignment_id)
		if is_challenge:
			send_check.call(LOCATION_CHALLENGE_FIRST_ASSIGNMENT_ID + assignment_id)
		if not slot_data.challengeMode:
			progression.mark_assignment_checked(assignment_name)
		if slot_data.challengeMode and is_challenge:
			progression.mark_assignment_checked(assignment_name)

	return is_async_won()
