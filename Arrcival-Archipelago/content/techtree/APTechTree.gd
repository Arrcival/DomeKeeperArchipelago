extends TechTree

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func buyCurrentUpgrade():
	if focussedTechPanel:
		var tech = GameWorld.upgrades.get(focussedTechPanel.techId)
		var bought: = false
		# let me buy stuff from AP in dev mode anyway
		if focussedTechPanel.state == 1 and GameWorld.devMode:
			super.buyCurrentUpgrade()
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

# copy paste just for the new TechTrack
func build(prefixMappings:Dictionary, rootsToIgnore:Array):
	trackIds.clear()
	
	var upgrades = Data.orderedUpgradeKeys.duplicate()
	var toErase := []
	for i in Data.orderedUpgradeKeys.size():
		var u = Data.orderedUpgradeKeys[i]
		if not GameWorld.upgrades.has(u):
			continue
		
		var upgrade = GameWorld.upgrades[u]
		if upgrade["tier"] == 0 and u in GameWorld.boughtUpgrades and not GameWorld.isUpgradeLimited(upgrade):
			if prefixMappings.has(u):
				trackIds.append([[prefixMappings[u] + "." + u]])
			else:
				if not rootsToIgnore.has(u):
					trackIds.append([[u]])
			toErase.append(u)
			continue

		var root = upgrade.get("root", "")
		if prefixMappings.has(upgrade.get("root", "")):
			upgrades[i] = prefixMappings[root] + "." +  upgrades[i]

	for u in toErase:
		upgrades.erase(u)
	
	# build tracks
	for track in trackIds:
		var removed := 1
		var currentTier := 1
		while removed > 0:
			removed = 0
			var newTechs := []
			for u in upgrades:
				if not GameWorld.upgrades.has(u):
					continue
				if GameWorld.lockedUpgrades.has(u):
					continue
				
				var upgrade = GameWorld.upgrades[u]
				if GameWorld.isUpgradeLimited(upgrade):
					continue
				
				if upgrade["tier"] != track.size():
					continue
				
				var predecessors:Array = upgrade.get("predecessors")
				var missingPredecessorCount := 1 if upgrade.get("predecessorsany", false) else predecessors.size()
				for predecessor in predecessors:
					if track[currentTier - 1].has(predecessor):
						missingPredecessorCount -= 1
				if missingPredecessorCount <= 0:
					newTechs.append(u)
			
			if newTechs.size() > 0:
				track.append(newTechs)
			for u in newTechs:
				upgrades.erase(u)
				removed += 1
			currentTier += 1
	
	focussedTechPanel = null
	for t in trackIds:
		var track = preload("res://mods-unpacked/Arrcival-Archipelago/content/techtree/APTechTrack.tscn").instantiate()
		track.build(t, self)
		$Tracks.add_child(track)
