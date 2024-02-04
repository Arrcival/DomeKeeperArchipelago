extends "res://game/GameWorld.gd"

var chat # used for logging stuff from AP

var archipelago = load("res://mods-unpacked/Arrcival-Archipelago/content/Archipelago.gd").new()

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func init():
	.init()
	archipelago.client.connect("item_received", archipelago, "item_found")

func levelInitialized():
	.levelInitialized()
	archipelago.generateUpgrades()
	archipelago.cobaltGiven = 0

func buyUpgrade(id: String):
	
	# prevention
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
