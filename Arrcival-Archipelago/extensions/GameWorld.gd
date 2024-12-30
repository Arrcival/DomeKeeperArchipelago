extends "res://game/GameWorld.gd"

var chat # used for logging stuff from AP

var archipelago = load("res://mods-unpacked/Arrcival-Archipelago/content/ArchipelagoData.gd").new()

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func init():
	super.init()
	# prevent randomizer to be on something the user hasn't unlocked
	# bruteforce unlock everything :/
	unlockEverything()
	archipelago.client.item_received.connect(archipelago.item_found)

func handleGameLost(backendData:Dictionary = {}):
	super.handleGameLost(backendData)
	if not won:
		archipelago.client.sendDeath("The dome was destroyed...")
	
func levelInitialized():
	super.levelInitialized()
	if GameWorld.archipelago.isRHMode():
		archipelago.generateUpgrades()
	archipelago.cobaltGiven = 0
	archipelago.cobaltGivenGA = 0
	archipelago.waterGivenGA = 0
	archipelago.ironGivenGA = 0

func prepareCleanData():
	super.prepareCleanData()
	Data.apply("map.totaltiles", 0)


func buyUpgrade(id:String):
	if not GameWorld.archipelago.isRHMode():
		return super.buyUpgrade(id)
	
	# preventing any crash from empty upgrades
	if id == "":
		return

	# Archipelago upgrades, default behavior
	if id.begins_with("archipelago"):
		archipelago.submitUpgrade(id)

	# Usual upgrades
	if not CONSTARRC.isUpgradePurchasable(id.to_lower()):
		return

	super.buyUpgrade(id)
