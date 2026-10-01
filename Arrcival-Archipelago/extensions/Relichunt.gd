extends "res://content/gamemode/relichunt/Relichunt.gd"

# Adding the archipelago tree to the tech tree
func afterInitialized():
	super.afterInitialized()
	GameWorld.addUpgrade("archipelago", "team1")

func propertyChanged(property: String, oldValue, newValue):
	super.propertyChanged(property, oldValue, newValue)
	if property == "game.over" and newValue == "won":
		if GameWorld.archipelago.miningEverything and Level.map.tileData.get_remaining_mineable_tile_count() <= 0:
			GameWorld.archipelago.complete_relichunt()
		else:
			GameWorld.archipelago.complete_relichunt()