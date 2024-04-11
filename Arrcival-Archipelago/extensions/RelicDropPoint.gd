extends "res://content/dome/RelicDropPoint.gd"

# Relic can arrive to the dome
# But won't "click" if the user hasn't mined every tiles
# Only happens when the user used the "mining everything" option
func arrived(relic):
	if GameWorld.archipelago.miningEverything:
		if Data.of("map.totaltiles") - Data.of("map.tilesdestroyed") + 1 > 0:
			return

	.arrived(relic)
