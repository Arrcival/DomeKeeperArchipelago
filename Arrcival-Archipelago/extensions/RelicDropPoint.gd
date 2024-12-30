extends "res://content/dome/RelicDropPoint.gd"

# Relic can arrive to the dome
# But won't "click" if the user hasn't mined every tiles
# Only happens when the user used the "mining everything" option
# Probably broken with bedrock
func arrived(relic):
	if GameWorld.archipelago.isRHMode() and GameWorld.archipelago.miningEverything:
		if Level.map.tileData.get_remaining_mineable_tile_count() > 0:
			return

	super.arrived(relic)
