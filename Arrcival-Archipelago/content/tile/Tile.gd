extends Tile

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

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

# Protect tile from being hit if the layer hasn't been accessed yet
# Work for everything (mining, sphere, drillbert, bomb...)
func hit(dir:Vector2, dmg:float):
	var biomeId = Level.map.getBiomeValueByCoord(coord)
	if not GameWorld.archipelago.hasLayerUnlocked(biomeId):
		return
	
	super.hit(dir, dmg)
