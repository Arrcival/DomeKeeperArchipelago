extends "res://systems/data/Data.gd"

func storeUpgradeData(key:String, currentData:Dictionary):
	if GameWorld.archipelago.isRHMode() and key == "archipelago":
		gadgets[key] = currentData
		if not orderedUpgradeKeys.has(key):
			orderedUpgradeKeys.insert(0, key)
	else:
		super.storeUpgradeData(key, currentData)

func parseUpgradesYaml(upgradesPath:String):
	super.parseUpgradesYaml(upgradesPath)
	var i = 1
