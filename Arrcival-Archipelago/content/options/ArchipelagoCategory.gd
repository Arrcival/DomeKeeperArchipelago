extends Node

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func _ready():
	find_node("SlotName").text = GameWorld.archipelago.slotName
	find_node("ServerName").text = GameWorld.archipelago.serverName
	find_node("Password").text = GameWorld.archipelago.password
	var archipelagoMod = ModLoaderMod.get_mod_data("Arrcival-Archipelago")
	find_node("Version").text = archipelagoMod.manifest.version_number

func _exit_tree():
	GameWorld.archipelago.slotName = find_node("SlotName").text
	GameWorld.archipelago.serverName = find_node("ServerName").text
	GameWorld.archipelago.password = find_node("Password").text
