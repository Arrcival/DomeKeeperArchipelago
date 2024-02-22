extends "res://game/GameWorld.gd"

var chat # used for logging stuff from AP

var archipelago = load("res://mods-unpacked/Arrcival-Archipelago/content/Archipelago.gd").new()

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func init():
	.init()
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
	archipelago.client.connect("item_received", archipelago, "item_found")

func levelInitialized():
	.levelInitialized()
	archipelago.generateUpgrades()
	archipelago.cobaltGiven = 0

func prepareCleanData():
	.prepareCleanData()
	Data.apply("map.totaltiles", 0)

func buyUpgrade(id: String):
	# preventing any crash from empty upgrades
	if id == "":
		return

	# Archipelago upgrades, default behavior
	if id.begins_with("archipelago"):
		archipelago.submitUpgrade(id)
		return .buyUpgrade(id)

	# Usual upgrades
	if CONSTARRC.isUpgradePurchasable(id):
		return .buyUpgrade(id)

	# Other upgrades (not default, not archipelago) should not spend cost but neither make sound
	var upgrade = GameWorld.upgrades.get(id)
	Backend.event("upgrade", {"id":id})
	unlockUpgrade(id)
	var shouldPlayMax = upgrade.get("tier", 0) >= 3 and upgrade.get("successors", []).empty()
	if upgrade.has("repeatable"):
		for propertyChange in upgrade.get("repeatable"):
			if propertyChange.keyClass == "times" and propertyChange.value == 0:
				shouldPlayMax = true
