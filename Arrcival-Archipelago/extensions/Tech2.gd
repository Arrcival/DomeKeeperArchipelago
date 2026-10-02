extends "res://content/techtree/Tech2.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var isArchipelagoLocked: bool = false

var crossIcon: TextureRect

func build(id:String, tier: = - 1):
	
	if not GameWorld.archipelago.is_relic_hunt():
		super.build(id, tier)
		return
	
	crossIcon = TextureRect.new()
	crossIcon.texture = preload("res://mods-unpacked/Arrcival-Archipelago/content/icons/cross/archipelagocross.png")
	crossIcon.position = Vector2.ONE * 27
	crossIcon.custom_minimum_size = Vector2.ONE * 60
	crossIcon.expand = true
	crossIcon.visible = false
	crossIcon.name = "IconCross"
	add_child(crossIcon)
	
	super.build(id, tier)
	
	if id.begins_with("team1.archipelagoupgrade"):
		explanationBb = getArchipelagoDescription(visualTechId)
	
	if id == "team1.archipelago":
		explanationBb += getRelicHuntStats()

	updateState()
	
	# Adding visuals for archipelago upgrades
	if id.begins_with("team1.archipelago"):
		icon = Data.loadIconOrFallback("res://mods-unpacked/Arrcival-Archipelago/content/icons/upgrades/" + visualTechId + ".png")
		find_child("Icon").texture = icon

	if not CONSTARRC.is_upgrade_purchasable(id):
		isArchipelagoLocked = true
		if crossIcon and state != State.BOUGHT:
			crossIcon.visible = true
			
	_on_Tech_focus_exited()

func getArchipelagoDescription(techId: String) -> String:
	return GameWorld.archipelago.get_upgrade_description(techId)

func getRelicHuntStats() -> String:
	return GameWorld.archipelago.get_relic_hunt_stats()

func reactivate():
	crossIcon.visible = false
