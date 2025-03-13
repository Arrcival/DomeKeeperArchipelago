extends Object

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func _ready(chain: ModLoaderHookChain):
	var main_node : Node = chain.reference_object
	var resourceSprite: Sprite2D = main_node.find_child("ResourceSprite")
	resourceSprite.texture = load("res://mods-unpacked/Arrcival-Archipelago/content/tile/resources_sheet_edited.png")
	chain.execute_next()

func setType(chain: ModLoaderHookChain, type:String):
	chain.execute_next([type])
	var main_node : Node = chain.reference_object
	if type == CONSTARRC.ARCHIPELAGOSWITCH:
		var baseHealth:float = Data.of("map.tileBaseHealth")
	
		main_node.set_meta("destructable", true)
		main_node.initResourceSprite(Vector2(5, 1))
		baseHealth += Data.of("map.relicAdditionalHealth")
	
		var healthMultiplier:float = Data.of("map.tileHealthBaseMultiplier")

		healthMultiplier *= (pow(Data.of("map.tileHealthMultiplierPerLayer"), main_node.layer))
		
		main_node.max_health = max(1, round(healthMultiplier * baseHealth))
		main_node.health = main_node.max_health
	
	if type == CONSTARRC.CHAMBER:
		var baseHealth:float = Data.of("map.tileBaseHealth")
	
		main_node.set_meta("destructable", true)
		main_node.initResourceSprite(Vector2(5, 2))
		baseHealth += Data.of("map.relicAdditionalHealth")
	
		var healthMultiplier:float = Data.of("map.tileHealthBaseMultiplier")

		healthMultiplier *= (pow(Data.of("map.tileHealthMultiplierPerLayer"), main_node.layer))
		
		main_node.max_health = max(1, round(healthMultiplier * baseHealth))
		main_node.health = main_node.max_health


# Protect tile from being hit if the layer hasn't been accessed yet
# Work for everything (mining, sphere, drillbert, bomb...) but not drill !!
func hit(chain: ModLoaderHookChain, dir:Vector2, dmg:float):
	var main_node : Node = chain.reference_object
	var biomeId = Level.map.tileData.get_biomev(main_node.coord)
	if GameWorld.archipelago.hasLayerUnlocked(biomeId):
		chain.execute_next([dir, dmg])
