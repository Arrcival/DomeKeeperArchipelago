class_name ArchipelagoRelicProgression

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var slot_data: ArchipelagoSlotData
var _tile_manager: ArchipelagoTileManager

var cobaltRetrieved: int = 0
var cobaltGiven: int = 0
var waterRetrieved: int = 0
var waterGiven: int = 0
var ironRetrieved: int = 0
var ironGiven: int = 0
var coloredLayersUnlocked: int = 0
var everyLayersUnlockFound: bool = false
# Pending Archipelago key item IDs, retained until LevelStage successfully spawns them.
var pending_keys: Array[int] = []

const KEY_FIRST_ID: int = 4242130
const KEY_COUNT: int = 10

signal log_informations(text: String)
signal trap_received

func setup(progression_slot_data: ArchipelagoSlotData, tile_manager: ArchipelagoTileManager) -> void:
	slot_data = progression_slot_data
	_tile_manager = tile_manager

func reset() -> void:
	cobaltRetrieved = 0
	cobaltGiven = 0
	waterRetrieved = 0
	waterGiven = 0
	ironRetrieved = 0
	ironGiven = 0
	coloredLayersUnlocked = 0
	everyLayersUnlockFound = false
	pending_keys.clear()

func reset_given_resources() -> void:
	cobaltGiven = 0
	waterGiven = 0
	ironGiven = 0

func process_item(item_id: int) -> bool:
	if item_id >= KEY_FIRST_ID and item_id <= KEY_FIRST_ID + 9:
		generate_key(item_id)
		return false

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

func generate_key(key_ap_id: int) -> void:
	if key_ap_id < KEY_FIRST_ID or key_ap_id >= KEY_FIRST_ID + KEY_COUNT:
		return
	if not pending_keys.has(key_ap_id):
		pending_keys.append(key_ap_id)

func get_pending_keys() -> Array[int]:
	return pending_keys.duplicate()

func consume_pending_key(key_ap_id: int) -> void:
	pending_keys.erase(key_ap_id)

func update_colored_layers() -> void:
	var layer_amount = slot_data.get_layer_amount()
	if coloredLayersUnlocked >= layer_amount:
		return
	coloredLayersUnlocked += 1
	_tile_manager.update_max_depth_hud()
	if coloredLayersUnlocked + 1 == layer_amount:
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

func get_layer_unlocked_amount() -> int:
	return coloredLayersUnlocked

func has_every_layers_unlocked():
	return everyLayersUnlockFound