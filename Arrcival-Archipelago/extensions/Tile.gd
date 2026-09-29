extends "res://content/map/tile/Tile.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func _ready():
	super._ready()
	var resourceSprite: Sprite2D = find_child("ResourceSprite")
	resourceSprite.texture = load("res://mods-unpacked/Arrcival-Archipelago/content/tile/resources_sheet_edited.png")

func setType(type:String):
	super.setType(type)
	if type == CONSTARRC.ARCHIPELAGOSWITCH:
		var baseHealth:float = Data.of("map.tileBaseHealth")
	
		set_meta("destructable", true)
		initResourceSprite(Vector2(5, 1))
		baseHealth += Data.of("map.relicAdditionalHealth")
	
		var healthMultiplier:float = Data.of("map.tileHealthBaseMultiplier")

		healthMultiplier *= (pow(Data.of("map.tileHealthMultiplierPerLayer"), layer))
		
		max_health = max(1, round(healthMultiplier * baseHealth))
		health = max_health
	
	if type == CONSTARRC.CHAMBER:
		var baseHealth:float = Data.of("map.tileBaseHealth")
	
		set_meta("destructable", true)
		initResourceSprite(Vector2(5, 2))
		baseHealth += Data.of("map.relicAdditionalHealth")
	
		var healthMultiplier:float = Data.of("map.tileHealthBaseMultiplier")

		healthMultiplier *= (pow(Data.of("map.tileHealthMultiplierPerLayer"), layer))
		
		max_health = max(1, round(healthMultiplier * baseHealth))
		health = max_health


# Protect tile from being hit if the layer hasn't been accessed yet
# Work for everything (mining, sphere, drillbert, bomb...) but not drill !!
# TODO: check if i'm wrong
func hit(dir: Vector2, dmg: float, teamId: String = "", keeperTechId: String = ""):
	var biomeId = Level.map.tileData.get_biomev(coord)
	if GameWorld.archipelago.hasLayerUnlocked(biomeId):
		super.hit(dir, dmg, teamId, keeperTechId)
