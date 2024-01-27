extends "res://content/dome/Dome.gd"


func onGameLost():
	.onGameLost()
	GameWorld.archipelago.client.sendDeath("The dome was destroyed...")
