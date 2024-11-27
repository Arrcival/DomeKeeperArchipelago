extends TechTrack

# copy paste except new Tech2 scene
func build(techsByTier:Array, focusListener: TechTree):
	# build tech data
	var tierN := 0
	var biggestTierSize = 1
	for tier in techsByTier:
		biggestTierSize = max(biggestTierSize, tier.size())
		var index = 0
		for techId in tier:
			var tierData := {"id":techId, "tier":tierN, "index":index, "children":[]}
			var tech = GameWorld.upgrades.get(techId)
			if tech.has("locks"):
				tierData["locks"] = tech.get("locks")
			if tech.has("requires"):
				tierData["requires"] = tech.get("requires")
			if tech.has("predecessors"):
				tierData["predecessors"] = tech.get("predecessors")
				var predecessorCount = getValidPredecessorCount(tech["predecessors"])
				index += predecessorCount - 1
				tierData["index"] = index
			techs[techId] = tierData
			if tierN == 0:
				rootTechId = techId
			index += 1
		tierN += 1

	# build forward links to child techs
	for tier in techsByTier:
		for techId in tier:
			var tech = GameWorld.upgrades.get(techId)
			if tech.has("predecessors"):
				for predId in tech.predecessors:
					if techs.has(predId):
						techs[predId].children.append(techId)

	# build lock groups
	for tier in techsByTier:
		var remainingTechs = tier.duplicate()
		
		var lockGroups := []
		while remainingTechs.size() > 0:
			var techId = remainingTechs.pop_front()
			var tech = techs[techId]
			if tech.has("locks"):
				var lockGroup := []
				for l in tech.get("locks"):
					if tier.has(l):
						lockGroup.append(l)
						remainingTechs.erase(l)
						techs[l]["lockGroup"] = lockGroup
				if lockGroup.size() > 0:
					lockGroup.append(techId)
					lockGroups.append(lockGroup)
					techs[techId]["lockGroup"] = lockGroup
		
		lockGroupsByTier.append(lockGroups)
	
	# create the ui elements
	var i := 0
	for tier in techsByTier:
		tier.sort_custom(Callable(self, "sortByPredecessorIndex"))
		var box := VBoxContainer.new()
		box.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if i < 2:
			box.alignment = BoxContainer.ALIGNMENT_CENTER
		else:
			box.alignment = BoxContainer.ALIGNMENT_BEGIN
		i +=1
		box.set("theme_override_constants/separation", 20)
		var panelsOfTier := []
		var index = 0
		for techId in tier:
			var tech = techs[techId]
			if i > 2 and tier.size() == 1 and tech.has("predecessors"):
				var predecessorCount = getValidPredecessorCount(tech["predecessors"])
				if predecessorCount > 1 and predecessorCount == prevTier.size():
					box.alignment = BoxContainer.ALIGNMENT_CENTER
			var boxToUse
			if tech.has("lockGroup"):
				var lockGroupId = tech.get("lockGroup").front()
				if lockGroupBoxes.has(lockGroupId):
					boxToUse = lockGroupBoxes.get(lockGroupId)
				else:
					var lockBox := PanelContainer.new()
					lockBox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
					lockBox.mouse_filter = Control.MOUSE_FILTER_IGNORE
					boxToUse = VBoxContainer.new()
					boxToUse.mouse_filter = Control.MOUSE_FILTER_IGNORE
					boxToUse.alignment = BoxContainer.ALIGNMENT_CENTER
					boxToUse.set("theme_override_constants/separation", 20)
					lockBox.set('theme_override_styles/panel', preload("res://content/techtree/panels/panel_lockgroup_open.tres"))
					lockGroupBoxes[lockGroupId] = boxToUse
					lockBox.add_child(boxToUse)
					box.add_child(lockBox)
			else:
				boxToUse = box
			
			# Add an empty tech to align vertically
			if i > 2 and techs.has(tech["predecessors"][0]) and techs[tech["predecessors"][0]]["index"] > index and tier.size() < biggestTierSize:
				for _n in range(techs[tech["predecessors"][0]]["index"] - index):
					techs[techId]["index"] = index+1
					var empty = preload("res://content/techtree/EmptyTech.tscn").instantiate()
					box.add_child(empty)
					box.move_child(empty, index)
					index += 1

			var panel = preload("res://mods-unpacked/Arrcival-Archipelago/content/techtree/APTech2.tscn").instantiate()
			panel.build(techId, i)
			panel.track = self
			techPanels[techId] = panel
			panelsOfTier.append(panel)
			boxToUse.add_child(panel)
			panel.connect("focus_entered", focusListener.technologyFocussed.bind(panel))
			panel.connect("focus_entered", techFocussed.bind(panel))
			panel.connect("focus_exited", Callable(focusListener, "techUnfocussed").bind(panel))
			panel.connect("gui_input", Callable(focusListener, "techInput").bind(panel))
			panel.connect("resized", Callable(self, "set").bind("dirty", true))

			index += 1

		find_child("Tiers").add_child(box)
		topTechPanelsByTier.append(panelsOfTier.front())
		bottomTechPanelsByTier.append(panelsOfTier.back())
		panelsByTier.append(panelsOfTier)
		rightTechPanels = panelsOfTier
		prevTier = tier
	
	# store information about the edges
	var lastTier := []
	for tier in techsByTier:
		for techId in tier:
			if techs[techId].has("predecessors"):
				var predecessors = techs[techId].get("predecessors")
				for r in predecessors:
					if lastTier.has(r):
						# a tech can have "any predecessor", where not every possible predecessor is there 
						edges.append([r, techId])
		lastTier = tier
