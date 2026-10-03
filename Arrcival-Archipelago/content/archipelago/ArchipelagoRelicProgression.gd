class_name ArchipelagoRelicProgression

var slot_data: ArchipelagoSlotData

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

func setup(progression_slot_data: ArchipelagoSlotData) -> void:
	slot_data = progression_slot_data

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

func process_item(item_id: int) -> bool:
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
			update_colored_layers()
		_:
			return false
	return true

func update_colored_layers() -> void:
	coloredLayersUnlocked += 1
	if coloredLayersUnlocked == slot_data.get_layer_amount():
		log_informations.emit("You unlocked every layers.")
		everyLayersUnlockFound = true

func get_relic_hunt_stats() -> String:
	var text = "\n\n"
	if GameWorld.archipelago.is_relic_hunt():
		if everyLayersUnlockFound:
			text += "You unlocked every layers\n"
		else:
			text += "Layers : " + str(coloredLayersUnlocked + 1) + "/" + str(slot_data.get_layer_amount()) + "\n"
	
		text += "Total iron received : " + str(ironRetrieved) + "\n"
		text += "Total water received : " + str(waterRetrieved) + "\n"
		text += "Total cobalt received : " + str(cobaltRetrieved) + "\n"
	return text