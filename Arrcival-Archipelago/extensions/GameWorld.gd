extends "res://game/GameWorld.gd"

var chat # used for logging stuff from AP

var archipelago = load("res://mods-unpacked/Arrcival-Archipelago/content/ArchipelagoData.gd").new()

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func init():
	super.init()
	# prevent randomizer to be on something the user hasn't unlocked
	# bruteforce unlock everything :/
	GameWorld.unlockElement("keeper1")
	GameWorld.unlockElement("keeper2")
	GameWorld.unlockElement("dome1")
	GameWorld.unlockElement("dome2")
	GameWorld.unlockElement("dome3")
	GameWorld.unlockElement("dome4")
	GameWorld.unlockElement("repellent")
	GameWorld.unlockElement("repellent-battle2")
	GameWorld.unlockElement("repellent-battle3")
	GameWorld.unlockElement("orchard")
	GameWorld.unlockElement("orchard-battle2")
	GameWorld.unlockElement("shield")
	GameWorld.unlockElement("shield-battle2")
	GameWorld.unlockElement("shield-battle3")
	GameWorld.unlockElement("droneyard")
	GameWorld.unlockElement("droneyard-battle2")
	GameWorld.unlockElement("droneyard-battle3")
	archipelago.client.item_received.connect(archipelago.item_found)

func handleGameLost(backendData:Dictionary = {}):
	super.handleGameLost(backendData)
	if not won:
		archipelago.client.sendDeath("The dome was destroyed...")
	
func levelInitialized():
	super.levelInitialized()
	archipelago.generateUpgrades()
	archipelago.cobaltGiven = 0

func prepareCleanData():
	super.prepareCleanData()
	Data.apply("map.totaltiles", 0)


func buyUpgrade(id:String):
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
