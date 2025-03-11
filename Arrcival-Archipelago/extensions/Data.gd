extends "res://systems/data/Data.gd"

# if archipelago : insert first so it's always at the top of the tech tree
func storeUpgradeData(key:String, currentData:Dictionary):
	if key == "archipelago":
		gadgets[key] = currentData
		if not orderedUpgradeKeys.has(key):
			orderedUpgradeKeys.insert(0, key)
	else:
		super.storeUpgradeData(key, currentData)
