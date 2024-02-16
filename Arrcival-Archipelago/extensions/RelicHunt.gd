extends "res://content/gamemode/relichunt/Relichunt.gd"


func afterInitialized():
	Level.stage.applyGadget("archipelago")

func propertyChanged(property:String, oldValue, newValue):
	.propertyChanged(property, oldValue, newValue)
		
	if property == "monsters.wavepresent" and not newValue:
		if GameWorld.archipelago.miningEverything:
			if GameWorld.archipelago.tilesLeft <= 0:
				GameWorld.archipelago.client.completedGoal()
		else:
			GameWorld.archipelago.client.completedGoal()
