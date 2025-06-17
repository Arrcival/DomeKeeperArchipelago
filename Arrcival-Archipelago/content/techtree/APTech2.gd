extends "res://content/techtree/Tech2.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var isArchipelagoLocked: bool = false

var crossIcon: TextureRect

func build(id:String, tier: = - 1):
	
	if not GameWorld.archipelago.isRHMode():
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
	
	if id.begins_with("archipelagoupgrade"):
		explanationBb = getArchipelagoDescription(visualTechId)
	
	if id == "archipelago":
		explanationBb += getRelicHuntStats()

	# Adding visuals for archipelago upgrades
	if id.begins_with("archipelago"):
		icon = Data.loadIconOrFallback("res://mods-unpacked/Arrcival-Archipelago/content/icons/upgrades/" + visualTechId + ".png")
		find_child("Icon").texture = icon


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

func getRelicHuntStats() -> String:
	if not GameWorld.archipelago.isRHMode(): #GA has no ap gadget
		return ""
	var text = "\n\n"
	if GameWorld.archipelago.progressionType == 1: # RH with colors
		if GameWorld.archipelago.everyLayersUnlockFound:
			text += "You unlocked every layers\n"
		else:
			text += "Layers : " + str(GameWorld.archipelago.coloredLayersUnlocked) + "/" + str(GameWorld.archipelago.get_layer_unlock_count()) + "\n"
	
		text += "Total iron received : " + str(GameWorld.archipelago.ironRetrieved) + "\n"
		text += "Total water received : " + str(GameWorld.archipelago.waterRetrieved) + "\n"
		text += "Total cobalt received : " + str(GameWorld.archipelago.cobaltRetrieved) + "\n"
	return text


func reactivate():
	crossIcon.visible = false
