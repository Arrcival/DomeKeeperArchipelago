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
	
	.build(id, tier)
	var idLowered = id.to_lower()
	if GameWorld.archipelago.lockedUpgrades.count(idLowered) > 0:
		isArchipelagoLocked = true
		if crossIcon:
			crossIcon.visible = true

	if id.begins_with("archipelago"):
		icon = load("res://mods-unpacked/Arrcival-Archipelago/content/icons/upgrades/" + visualTechId + ".png")
		find_node("Icon").texture = icon

func reactivate():
	crossIcon.visible = false
	isArchipelagoLocked = false
