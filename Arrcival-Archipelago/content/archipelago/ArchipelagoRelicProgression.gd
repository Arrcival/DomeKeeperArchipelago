class_name ArchipelagoRelicProgression

var cobaltRetrieved: int = 0
var cobaltGiven: int = 0
var waterRetrieved: int = 0
var waterGiven: int = 0
var ironRetrieved: int = 0
var ironGiven: int = 0
var coloredLayersUnlocked: int = 0
var everyLayersUnlockFound: bool = false
var total_layer_count: int = 3

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
	total_layer_count = layer_unlock_count
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
	if coloredLayersUnlocked >= total_layer_count:
		log_informations.emit("You unlocked every layers.")
		everyLayersUnlockFound = true

func get_relic_hunt_stats() -> String:
	var text = "\n\n"
	if GameWorld.archipelago.is_relic_hunt_with_colored_layers():
		if everyLayersUnlockFound:
			text += "You unlocked every layers\n"
		else:
			text += "Layers : " + str(coloredLayersUnlocked + 1) + "/" + str(total_layer_count) + "\n"
	
		text += "Total iron received : " + str(ironRetrieved) + "\n"
		text += "Total water received : " + str(waterRetrieved) + "\n"
		text += "Total cobalt received : " + str(cobaltRetrieved) + "\n"
	return text