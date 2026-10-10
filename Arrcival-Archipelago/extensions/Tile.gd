extends "res://content/map/tile/Tile.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var distance_to_dome = 0

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
	
	if type == CONSTARRC.AP_CHAMBER:
		var baseHealth:float = Data.of("map.tileBaseHealth")
	
		set_meta("destructable", true)
		initResourceSprite(Vector2(5, 2))
		baseHealth += Data.of("map.relicAdditionalHealth")
	
		var healthMultiplier:float = Data.of("map.tileHealthBaseMultiplier")

		healthMultiplier *= (pow(Data.of("map.tileHealthMultiplierPerLayer"), layer))
		
		max_health = max(1, round(healthMultiplier * baseHealth))
		health = max_health

	if type == CONSTARRC.AP_CHEST:
		var baseHealth:float = Data.of("map.tileBaseHealth")
	
		set_meta("destructable", true)
		initResourceSprite(Vector2(5, 0))
		baseHealth += Data.of("map.relicAdditionalHealth")
	
		var healthMultiplier:float = Data.of("map.tileHealthBaseMultiplier")

		healthMultiplier *= (pow(Data.of("map.tileHealthMultiplierPerLayer"), layer))
		
		max_health = max(1, round(healthMultiplier * baseHealth))
		health = max_health

	distance_to_dome = GameWorld.archipelago.get_cell_distance(coord)


# Protect tile from being hit if the layer hasn't been accessed yet
func hit(dir: Vector2, dmg: float, teamId: String = "", keeperTechId: String = ""):
	if GameWorld.archipelago.has_tile_unlocked(distance_to_dome):
		super.hit(dir, dmg, teamId, keeperTechId)

	# should be moved cause any tile hit will occur that
	if distance_to_dome == 0 or distance_to_dome == null:
		Data.apply("team1.archipelago.depth", 0)
	else:
		Data.apply("team1.archipelago.depth", distance_to_dome)
