extends Node

func _ready():
	find_node("SlotName").text = GameWorld.archipelago.slotName
	find_node("ServerName").text = GameWorld.archipelago.serverName
	find_node("Password").text = GameWorld.archipelago.password

func _exit_tree():
	GameWorld.archipelago.slotName = find_node("SlotName").text
	GameWorld.archipelago.serverName = find_node("ServerName").text
	GameWorld.archipelago.password = find_node("Password").text
