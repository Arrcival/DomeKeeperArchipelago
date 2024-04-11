extends "res://content/techtree/Tech2.gd"


const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var isArchipelagoLocked = false

var crossIcon

func build(id:String, tier: = - 1):
	crossIcon = TextureRect.new()
	crossIcon.texture = preload("res://mods-unpacked/Arrcival-Archipelago/content/cross/archipelagocross.png")
	crossIcon.rect_position = Vector2.ONE * 27
	crossIcon.rect_min_size = Vector2.ONE * 60
	crossIcon.expand = true
	crossIcon.visible = false
	crossIcon.name = "IconCross"
	add_child(crossIcon)
	
	# .build()
	self.techId = id
	var data = GameWorld.upgrades.get(id)
	visualTechId = data.get("shadowing", techId)
	if tier == 1:
		state = State.INITIAL
		$Icon.rect_min_size = Vector2.ONE * 144
		$Icon.rect_position = Vector2( - 4, - 4)
		texture = preload("res://content/techtree/panels/big.png")
		$SelectedPanel.texture = preload("res://content/techtree/panels/big_focus.png")
	$SelectedPanel.visible = false
	if data.has("cost"):
		var cost = data.get("cost")
		var costsBox = find_node("Costs")
		for costType in cost:
			var label = Label.new()
			label.align = Label.ALIGN_RIGHT
			label.size_flags_horizontal = label.SIZE_EXPAND_FILL
			label.text = str(cost[costType])
			label.add_font_override("font", preload("res://gui/fonts/FontNumbers.tres"))
			label.add_to_group("unstyled")
			costsBox.add_child(label)
			costLabels[costType] = label
			
			var rect = TextureRect.new()
			var tex:Texture
			match costType:
				CONST.WATER:
					tex = preload("res://content/icons/icon_water.png")
				CONST.IRON:
					tex = preload("res://content/icons/icon_iron.png")
				CONST.SAND:
					tex = preload("res://content/icons/icon_sand.png")
			rect.texture = tex
			costsBox.add_child(rect)
	
	propertyChanges = data.get("propertychanges", [])
	
	title = tr("upgrades." + visualTechId + ".title")
	
	if id.begins_with("archipelagoupgrade"):
		explanationBb = getArchipelagoDescription(visualTechId)
	else:
		explanationBb = GameWorld.iconify(tr("upgrades." + visualTechId + ".desc"))
	
	updateState()
	# end .build()
	

	# Adding visuals for archipelago upgrades
	if id.begins_with("archipelago"):
		icon = load("res://mods-unpacked/Arrcival-Archipelago/content/icons/upgrades/" + visualTechId + ".png")
		find_node("Icon").texture = icon
	else:
		icon = load("res://content/icons/" + visualTechId + ".png")
		find_node("Icon").texture = icon
		

	var idLowered = id.to_lower()
	if not CONSTARRC.isUpgradePurchasable(id):
		isArchipelagoLocked = true
		if crossIcon and state != State.BOUGHT:
			crossIcon.visible = true
			
	_on_Tech_focus_exited()

func getArchipelagoDescription(techId: String) -> String:
	if not GameWorld.archipelago.locationIds.has(techId):
		return ""
	var techNumber: int = GameWorld.archipelago.locationIds[techId]
	
	if GameWorld.archipelago.hasLocationChecked(techNumber, techId):
		return "Location already checked!"
	
	if not GameWorld.archipelago.locationScouts.has(techNumber):
		return ""
	
	return GameWorld.archipelago.locationScouts[techNumber]
	
func reactivate():
	crossIcon.visible = false
