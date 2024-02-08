extends "res://content/map/tile/Tile.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func _ready():
	if type == CONSTARRC.ARCHIPELAGOSWITCH:
		print("Went here with archipelagoswitch")
		var baseHealth:float = Data.of("map.tileBaseHealth")
	
		set_meta("destructable", true)
		initResourceSprite(Vector2(5, 1))
		baseHealth += Data.of("map.relicAdditionalHealth")
	
		var healthMultiplier:float = Data.of("map.tileHealthBaseMultiplier")
				
		healthMultiplier *= (pow(Data.of("map.tileHealthMultiplierPerLayer"), layer))
		
		max_health = max(1, round(healthMultiplier * baseHealth))
		if hasRoots:
			max_health *= 5
		health = max_health

