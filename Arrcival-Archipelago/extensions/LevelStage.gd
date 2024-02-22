extends "res://stages/level/LevelStage.gd"

func _ready():
	GameWorld.archipelago.client.connect("onDeathFound", self, "makeUserLose")

func _process(deltaTime: float):
	
	var upgrades: Array = GameWorld.archipelago.checkUpgrades()
	if upgrades.size() > 0:
		var tree = get_tree()
		if tree != null:
			var nodes = tree.get_nodes_in_group("techpanel")
			if nodes != null and nodes.size() > 0:
				for node in nodes:
					if upgrades.has(node.techId):
						node.reactivate()

	if GameWorld.archipelago.cobaltGiven < GameWorld.archipelago.cobaltRetrieved:
		Data.changeByInt("inventory.sand", GameWorld.archipelago.cobaltRetrieved - GameWorld.archipelago.cobaltGiven)
		GameWorld.archipelago.cobaltGiven = GameWorld.archipelago.cobaltRetrieved

func makeUserLose():
	Data.changeDomeHealth( - 999999)

func beforeStart():
	.beforeStart()
	Data.listen(self, "map.tilesdestroyed")
	GameWorld.archipelago.scoutUpgrades()
	
func propertyChanged(property:String, oldValue, newValue):
	.propertyChanged(property, oldValue, newValue)
	if property == "map.tilesdestroyed":
		var totalTiles = Data.of("map.totaltiles") + 1
		var tilesDestroyed = Data.of("map.tilesdestroyed")
		var tilesLeft = totalTiles - tilesDestroyed
		
		GameWorld.archipelago.tilesLeft = tilesLeft

