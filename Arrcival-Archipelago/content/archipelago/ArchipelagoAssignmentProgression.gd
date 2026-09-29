class_name ArchipelagoAssignmentProgression

const CONSTARRC: GDScript = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")
const ITEM_FIRST_ASSIGNMENT_ID: int = 4242200
const ASSIGNMENT_UNLOCK_COUNT: int = 25

var cobaltRetrieved: int = 0
var cobaltGiven: int = 0
var waterRetrieved: int = 0
var waterGiven: int = 0
var ironRetrieved: int = 0
var ironGiven: int = 0
var miningStrengthRetrieved: int = 0
var miningStrengthGiven: int = 0
var movementSpeedRetrieved: int = 0
var movementSpeedGiven: int = 0
var assignmentsUnlocked: Dictionary = {}
var assignmentsChecked: Dictionary = {}

signal assignment_unlocked(id: int)

func reset() -> void:
	cobaltRetrieved = 0
	cobaltGiven = 0
	waterRetrieved = 0
	waterGiven = 0
	ironRetrieved = 0
	ironGiven = 0
	miningStrengthRetrieved = 0
	miningStrengthGiven = 0
	movementSpeedRetrieved = 0
	movementSpeedGiven = 0
	assignmentsUnlocked = CONSTARRC.ASSIGNMENTS_DEFAULT_EMPTY.duplicate()
	assignmentsChecked = CONSTARRC.ASSIGNMENTS_DEFAULT_EMPTY.duplicate()

func reset_given_resources() -> void:
	cobaltGiven = 0
	waterGiven = 0
	ironGiven = 0

func is_assignment_unlock_item(item_id: int) -> bool:
	return item_id >= ITEM_FIRST_ASSIGNMENT_ID and item_id < ITEM_FIRST_ASSIGNMENT_ID + ASSIGNMENT_UNLOCK_COUNT

func handles_item(item_id: int) -> bool:
	return (
		item_id >= ITEM_FIRST_ASSIGNMENT_ID
		and item_id < ITEM_FIRST_ASSIGNMENT_ID + ASSIGNMENT_UNLOCK_COUNT
	) or item_id in [4242230, 4242231, 4242232, 4242233, 4242234]

func process_item(item_id: int) -> bool:
	if item_id >= ITEM_FIRST_ASSIGNMENT_ID and item_id < ITEM_FIRST_ASSIGNMENT_ID + ASSIGNMENT_UNLOCK_COUNT:
		receive_unlock(item_id)
		return true

	match item_id:
		4242230:
			ironRetrieved += 1
		4242231:
			waterRetrieved += 1
		4242232:
			cobaltRetrieved += 1
		4242233:
			miningStrengthRetrieved += 1
		4242234:
			movementSpeedRetrieved += 1
		_:
			return false
	return true

func receive_unlock(item_id: int) -> void:
	var unlock_id: int = item_id - ITEM_FIRST_ASSIGNMENT_ID
	if unlock_id < 0 or unlock_id >= CONSTARRC.ASSIGNMENTS_LIST.size():
		push_warning("Invalid assignment unlock item ID: %s" % item_id)
		return

	var assignment_name: String = CONSTARRC.ASSIGNMENTS_LIST[unlock_id]
	assignmentsUnlocked[assignment_name] = true
	assignment_unlocked.emit(unlock_id)

func mark_assignment_checked(assignment_name: String) -> void:
	if assignmentsChecked.has(assignment_name):
		assignmentsChecked[assignment_name] = true

func is_assignment_unlocked(assignment_name: String) -> bool:
	return assignmentsUnlocked.get(assignment_name, false)

func is_assignment_done(assignment_name: String) -> bool:
	return assignmentsChecked.get(assignment_name, false)

func get_starting_assignment_name(starting_assignment: int) -> String:
	if starting_assignment < 0 or starting_assignment >= CONSTARRC.ASSIGNMENTS_LIST.size():
		push_warning("Invalid starting assignment ID: %s" % starting_assignment)
		return ""
	return CONSTARRC.ASSIGNMENTS_LIST[starting_assignment]

func is_async_won(assignments_amount: int) -> bool:
	var won_assignments: int = 0
	for value: Variant in assignmentsChecked.values():
		if value == true:
			won_assignments += 1
	return won_assignments >= assignments_amount
