extends "res://stages/loadout/RelichuntPopup.gd"


func init():
	.init()
	
	var difficultiesNode = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer
	
	for difficultyButton in difficultiesNode.get_children():
		difficultyButton.disabled = true
	
	var mapSizeNode = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer/PanelContainer2/MarginContainer/MapSizeBox/HBoxContainer3
	
	for difficultyButton in mapSizeNode.get_children():
		difficultyButton.disabled = true
	
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3.visible = false
	
	var Mbox = find_node("Modifiers")
	for button in Mbox.get_children():
		button.pressed = false
		button.disabled = true
	
	
	updateBasedOnClient()
	Style.init(self)


func updateBasedOnClient():
	match GameWorld.archipelago.client._difficulty:
		0:
			GameWorld.loadoutStageConfig.difficulty = - 2
		1:
			GameWorld.loadoutStageConfig.difficulty = - 1
		2:
			GameWorld.loadoutStageConfig.difficulty = 0
		3:
			GameWorld.loadoutStageConfig.difficulty = 2
	match GameWorld.archipelago.client._mapSize:
		0:
			GameWorld.loadoutStageConfig.modeConfig[CONST.MODE_CONFIG_RELICHUNT_MAPSIZE] = CONST.MAP_SMALL
		1:
			GameWorld.loadoutStageConfig.modeConfig[CONST.MODE_CONFIG_RELICHUNT_MAPSIZE] = CONST.MAP_MEDIUM
		2:
			GameWorld.loadoutStageConfig.modeConfig[CONST.MODE_CONFIG_RELICHUNT_MAPSIZE] = CONST.MAP_LARGE
		3:
			GameWorld.loadoutStageConfig.modeConfig[CONST.MODE_CONFIG_RELICHUNT_MAPSIZE] = CONST.MAP_HUGE
