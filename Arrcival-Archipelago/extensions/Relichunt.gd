extends "res://content/gamemode/relichunt/Relichunt.gd"

# Adding the archipelago tree to the tech tree
func afterInitialized():
	super.afterInitialized()
	GameWorld.addUpgrade("archipelago", "team1")

# Listening to wave end for victory
func propertyChanged(property:String, oldValue, newValue):
	super.propertyChanged(property, oldValue, newValue)
		
	if property == "monsters.wavepresent" and not newValue:
		if GameWorld.archipelago.miningEverything:
			if Level.map.tileData.get_remaining_mineable_tile_count() <= 0:
				GameWorld.archipelago.complete_relichunt()
		else:
			GameWorld.archipelago.complete_relichunt()
