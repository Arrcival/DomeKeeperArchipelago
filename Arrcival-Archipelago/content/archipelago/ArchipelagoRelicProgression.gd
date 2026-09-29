class_name ArchipelagoRelicProgression

var cobaltRetrieved: int = 0
var cobaltGiven: int = 0
var waterRetrieved: int = 0
var waterGiven: int = 0
var ironRetrieved: int = 0
var ironGiven: int = 0
var coloredLayersUnlocked: int = 0
var everyLayersUnlockFound: bool = false

signal log_informations(text: String)
signal trap_received

func reset() -> void:
	cobaltRetrieved = 0
	cobaltGiven = 0
	waterRetrieved = 0
	waterGiven = 0
	ironRetrieved = 0
	ironGiven = 0
	coloredLayersUnlocked = 0
	everyLayersUnlockFound = false

func reset_given_resources() -> void:
	cobaltGiven = 0
	waterGiven = 0
	ironGiven = 0

func handles_item(item_id: int) -> bool:
	return item_id in [4242090, 4242091, 4242092, 4242095, 4242100]

func process_item(item_id: int, layer_unlock_count: int) -> bool:
	match item_id:
		4242090:
			cobaltRetrieved += 1
		4242091:
			waterRetrieved += 1
		4242092:
			ironRetrieved += 1
		4242095:
			trap_received.emit()
		4242100:
			update_colored_layers(layer_unlock_count)
		_:
			return false
	return true

func update_colored_layers(layer_unlock_count: int) -> void:
	coloredLayersUnlocked += 1
	if coloredLayersUnlocked >= layer_unlock_count:
		log_informations.emit("You unlocked every layers.")
		everyLayersUnlockFound = true
