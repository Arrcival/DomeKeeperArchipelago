extends Node

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func _ready():
	find_node("SlotName").text = GameWorld.archipelago.slotName
	find_node("ServerName").text = GameWorld.archipelago.serverName
	find_node("Password").text = GameWorld.archipelago.password
	var archipelagoMod = ModLoaderMod.get_mod_data("Arrcival-Archipelago")
	find_node("Version").text = archipelagoMod.manifest.version_number
	find_node("ExtraInfos").text = CONSTARRC.ADDITIONNAL_INFOS

func _exit_tree():
	GameWorld.archipelago.slotName = find_node("SlotName").text
	GameWorld.archipelago.serverName = find_node("ServerName").text
	GameWorld.archipelago.password = find_node("Password").text
	
	var dict = generateDictionaryOptions()
	saveArchipelagoOptions(CONSTARRC.SAVE_OPTIONS_ARCHIPELAGO, dict)

func generateDictionaryOptions() -> Dictionary:
	return {
		"slotName": GameWorld.archipelago.slotName,
		"serverName": GameWorld.archipelago.serverName,
		"password": GameWorld.archipelago.password
	}

func saveArchipelagoOptions(path: String, thing_to_save):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_var(thing_to_save)
	file.close()
