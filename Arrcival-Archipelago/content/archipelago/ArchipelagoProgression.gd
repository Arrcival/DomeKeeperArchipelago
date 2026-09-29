class_name ArchipelagoProgression

const CONSTARRC: GDScript = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")
const ITEM_FIRST_ASSIGNMENT_ID: int = 4242200

var cobaltRetrieved: int = 0
var cobaltGiven: int = 0
var waterRetrieved: int = 0
var waterGiven: int = 0
var ironRetrieved: int = 0
var ironGiven: int = 0

var cobaltRetrievedGA: int = 0
var cobaltGivenGA: int = 0
var waterRetrievedGA: int = 0
var waterGivenGA: int = 0
var ironRetrievedGA: int = 0
var ironGivenGA: int = 0
var miningStrengthRetrievedGA: int = 0
var miningStrengthGivenGA: int = 0
var movementSpeedRetrievedGA: int = 0
var movementSpeedGivenGA: int = 0

var assignmentsUnlocked: Dictionary = {}
var assignmentsChecked: Dictionary = {}
var coloredLayersUnlocked: int = 0
var everyLayersUnlockFound: bool = false
var current_assignment: String = ""
var died_to_death_link: bool = false

signal log_informations(text: String)
signal assignment_unlocked(id: int)

func reset() -> void:
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
	miningStrengthRetrievedGA = 0
	miningStrengthGivenGA = 0
	movementSpeedRetrievedGA = 0
	movementSpeedGivenGA = 0
	coloredLayersUnlocked = 0
	everyLayersUnlockFound = false
	current_assignment = ""
	died_to_death_link = false
	assignmentsUnlocked = CONSTARRC.ASSIGNMENTS_DEFAULT_EMPTY.duplicate()
	assignmentsChecked = CONSTARRC.ASSIGNMENTS_DEFAULT_EMPTY.duplicate()

func reset_given_resources() -> void:
	cobaltGiven = 0
	waterGiven = 0
	ironGiven = 0
	cobaltGivenGA = 0
	waterGivenGA = 0
	ironGivenGA = 0

func mark_death_link_death() -> void:
	died_to_death_link = true

func consume_death_link_death() -> bool:
	if not died_to_death_link:
		return false
	died_to_death_link = false
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

func update_colored_layers(layer_unlock_count: int) -> void:
	coloredLayersUnlocked += 1
	if coloredLayersUnlocked >= layer_unlock_count:
		log_informations.emit("You unlocked every layers.")
		everyLayersUnlockFound = true

func is_assignment_unlocked(assignment_name: String) -> bool:
	return assignmentsUnlocked.get(assignment_name, false)

func is_assignment_done(assignment_name: String) -> bool:
	return assignmentsChecked.get(assignment_name, false)

func is_async_won(assignments_amount: int) -> bool:
	var won_assignments: int = 0
	for value: Variant in assignmentsChecked.values():
		if value == true:
			won_assignments += 1
	return won_assignments >= assignments_amount

func get_starting_assignment_name(starting_assignment: int) -> String:
	if starting_assignment < 0 or starting_assignment >= CONSTARRC.ASSIGNMENTS_LIST.size():
		push_warning("Invalid starting assignment ID: %s" % starting_assignment)
		return ""
	return CONSTARRC.ASSIGNMENTS_LIST[starting_assignment]
