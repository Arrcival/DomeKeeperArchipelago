extends "res://content/gamemode/relichunt/Relichunt.gd"

# Adding the archipelago tree to the tech tree
func afterInitialized():
	GameWorld.addUpgrade("archipelago")

# Listening to wave end for victory
func propertyChanged(property:String, oldValue, newValue):
	super.propertyChanged(property, oldValue, newValue)
		
	if property == "monsters.wavepresent" and not newValue:
		if GameWorld.archipelago.miningEverything:
			if Level.map.tileData.get_remaining_mineable_tile_count() <= 0:
				GameWorld.archipelago.client.completedGoal()
		else:
			GameWorld.archipelago.client.completedGoal()
