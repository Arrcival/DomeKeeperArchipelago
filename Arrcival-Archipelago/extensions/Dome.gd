extends "res://content/dome/Dome.gd"

func onGameLost():
	super.onGameLost()
	GameWorld.archipelago.client.sendDeath("The dome was destroyed...")
