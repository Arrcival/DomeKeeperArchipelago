extends "res://content/gamemode/relichunt/Relichunt.gd"

# Adding the archipelago tree to the tech tree
func afterInitialized():
	Level.stage.applyGadget("archipelago")

# Listening to wave end for victory
func propertyChanged(property:String, oldValue, newValue):
	.propertyChanged(property, oldValue, newValue)
		
	if property == "monsters.wavepresent" and not newValue:
		if GameWorld.archipelago.miningEverything:
			if GameWorld.archipelago.tilesLeft <= 0:
				GameWorld.archipelago.client.completedGoal()
		else:
			GameWorld.archipelago.client.completedGoal()
