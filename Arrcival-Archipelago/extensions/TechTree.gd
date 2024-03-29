extends "res://content/techtree/TechTree.gd"


const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var archipelagoTimesBought = 0


func buyCurrentUpgrade():
	if focussedTechPanel:
		var tech = GameWorld.upgrades.get(focussedTechPanel.techId)
		if focussedTechPanel.state == 1 and GameWorld.devMode:
			.buyCurrentUpgrade()
		elif focussedTechPanel.state == 1 and not focussedTechPanel.isArchipelagoLocked:
			.buyCurrentUpgrade()
			if focussedTechPanel.techId.begins_with("archipelagoupgrade"):
				GameWorld.archipelago.upgradesBought.append(focussedTechPanel.techId)
		else:
			focussedTechPanel.error()
