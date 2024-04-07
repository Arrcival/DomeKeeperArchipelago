extends "res://content/techtree/TechTree.gd"


const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var archipelagoTimesBought = 0


func buyCurrentUpgrade():
	if focussedTechPanel:
		var tech = GameWorld.upgrades.get(focussedTechPanel.techId)
		var bought: = false
		if focussedTechPanel.state == 1 and GameWorld.devMode:
			.buyCurrentUpgrade()
		elif focussedTechPanel.state == 1 and not focussedTechPanel.isArchipelagoLocked:
			if GameWorld.canAfford(tech.get("cost", {})):
				bought = true
				GameWorld.buyUpgrade(focussedTechPanel.techId)
				focussedTechPanel.upgrade()
				focussedTechPanel.track.updateState()
				emit_signal("techFocussed", focussedTechPanel)
				focussedTechPanel.track.updateLineColors()
				focussedTechPanel.track.updateLines()
		if not bought:
			focussedTechPanel.error()
		else:
			if focussedTechPanel.techId.begins_with("archipelagoupgrade"):
				GameWorld.archipelago.upgradesBought.append(focussedTechPanel.techId)
