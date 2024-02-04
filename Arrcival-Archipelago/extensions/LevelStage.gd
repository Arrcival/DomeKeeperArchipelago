extends "res://stages/level/LevelStage.gd"

func _ready():
	GameWorld.archipelago.client.connect("onDeathFound", self, "makeUserLose")

func _process(deltaTime: float):
	
	var upgrades: Array = GameWorld.archipelago.checkUpgrades()
	if upgrades.size() > 0:
		var nodes = get_tree().get_nodes_in_group("techpanel")
		for node in nodes:
			if upgrades.has(node.techId):
				node.reactivate()

	if GameWorld.archipelago.cobaltGiven < GameWorld.archipelago.cobaltRetrieved:
		Data.changeByInt("inventory.sand", GameWorld.archipelago.cobaltRetrieved - GameWorld.archipelago.cobaltGiven)
		GameWorld.archipelago.cobaltGiven = GameWorld.archipelago.cobaltRetrieved

func makeUserLose():
	Data.changeDomeHealth( - 999999)
