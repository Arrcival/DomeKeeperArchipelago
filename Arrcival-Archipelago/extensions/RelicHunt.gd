extends "res://content/gamemode/relichunt/Relichunt.gd"


func afterInitialized():
	Level.stage.applyGadget("archipelago")

func propertyChanged(property:String, oldValue, newValue):
	.propertyChanged(property, oldValue, newValue)
	if property == "monsters.wavepresent" and not newValue:
		GameWorld.archipelago.client.completedGoal()
