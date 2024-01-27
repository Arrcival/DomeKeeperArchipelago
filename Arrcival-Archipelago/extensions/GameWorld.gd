extends "res://game/GameWorld.gd"

var chat # used for logging stuff from AP

var archipelago = load("res://mods-unpacked/Arrcival-Archipelago/content/Archipelago.gd").new()

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")



func levelInitialized():
	.levelInitialized()
	archipelago.generateUpgrades()
	archipelago.cobaltGiven = 0

func buyUpgrade(upgradeName: String):
	.buyUpgrade(upgradeName)
	
	if upgradeName.begins_with("archipelago"):
		archipelago.submitUpgrade(upgradeName)
