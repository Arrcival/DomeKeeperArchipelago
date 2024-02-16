extends "res://content/dome/RelicDropPoint.gd"


func arrived(relic):
	if GameWorld.archipelago.miningEverything:
		if Data.of("map.totaltiles") - Data.of("map.tilesdestroyed") + 1 > 0:
			return

	.arrived(relic)
