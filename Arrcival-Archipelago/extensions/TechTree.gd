extends "res://content/techtree/TechTree.gd"


const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var archipelagoTimesBought = 0


func buyCurrentUpgrade():
	if focussedTechPanel:
		var tech = GameWorld.upgrades.get(focussedTechPanel.techId)
		if focussedTechPanel.state == 1 and not focussedTechPanel.isArchipelagoLocked:
			.buyCurrentUpgrade()
		else:
			focussedTechPanel.error()
