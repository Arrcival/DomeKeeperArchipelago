extends "res://content/map/Map.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

const ARCHIPELAGO_CAVE_SCENE: Resource = preload("res://mods-unpacked/Arrcival-Archipelago/content/cave/ArchipelagoCave.tscn")

func init(fromDeserialize: = false, defaultState := true):
	Data.TILE_ID_TO_STRING_MAP.merge({CONSTARRC.TILE_ARCHIPELAGO_SWITCH:CONSTARRC.ARCHIPELAGOSWITCH})
	Data.TILE_ID_TO_STRING_MAP.merge({CONSTARRC.TILE_CHAMBER:CONSTARRC.AP_CHAMBER})
	Data.TILE_ID_TO_STRING_MAP.merge({CONSTARRC.TILE_CHEST:CONSTARRC.AP_CHEST})
	super.init(fromDeserialize, defaultState)
	
	if not fromDeserialize:
		var clusterCenters = tileData.get_resource_cells_by_id(CONSTARRC.TILE_ARCHIPELAGO_SWITCH)
		if clusterCenters.size() > 0 and (GameWorld.devMode or OS.is_debug_build()):
			print("Tile AP switches :", clusterCenters)
		for tile in clusterCenters:
			addChamber(tile, getSceneForTileType(CONSTARRC.TILE_ARCHIPELAGO_SWITCH))
		
		if GameWorld.devMode:
			addChamber(Vector2(0, 2), getSceneForTileType(CONSTARRC.TILE_ARCHIPELAGO_SWITCH))

static func generateChamberPlacements(tileData) -> Dictionary:
	var apChamberOrigins: Array = tileData.get_resource_cells_by_id(CONSTARRC.TILE_CHAMBER)
	var apChestOrigins: Array = tileData.get_resource_cells_by_id(CONSTARRC.TILE_CHEST)
	var placements: Dictionary = super.generateChamberPlacements(tileData)
	placements[CONSTARRC.TILE_CHAMBER] = apChamberOrigins
	placements[CONSTARRC.TILE_CHEST] = apChestOrigins
	return placements

func getSceneForTileType(tileType:int) -> PackedScene:
	if tileType == CONSTARRC.TILE_ARCHIPELAGO_SWITCH:
		return preload("res://mods-unpacked/Arrcival-Archipelago/content/switch/ArchipelagoSwitch.tscn")
	if tileType == CONSTARRC.TILE_CHAMBER:
		return preload("res://mods-unpacked/Arrcival-Archipelago/content/chamber/ArchipelagoChamber.tscn")
	if tileType == CONSTARRC.TILE_CHEST:
		return preload("res://mods-unpacked/Arrcival-Archipelago/content/chest/ArchipelagoChest.tscn")
	return super.getSceneForTileType(tileType)

# Add one archipelago cave per generated layer.
func addCaves(minDistanceToCenter: = 10):
	super.addCaves(minDistanceToCenter)

	if not GameWorld.archipelago.is_relic_hunt():
		return

	var layers: Array = GameWorld.archipelago.get_generated_layers()
	var layerCount: int = layers.size()
	if GameWorld.devMode:
		layerCount = mini(3, layerCount)

	for layerIndex in range(layerCount):
		addArchipelagoCave(layerIndex, layers[layerIndex])

func addArchipelagoCave(layerIndex: int, layerCells: Array) -> void:
	var cave: Node = ARCHIPELAGO_CAVE_SCENE.instantiate()
	cave.updateUsedTileCoords()

	var shuffledCells: Array = Data.seedShuffle(layerCells, Level.levelSeed)

	for cell in shuffledCells:
		if not tileData.is_area_free(cell, cave.tileCoords):
			continue

		var validLayerArea := true
		for offset in cave.tileCoords:
			var caveCell := Vector2i(cell) + Vector2i(offset)
			if not layerCells.has(caveCell) or isCellInProtectedCells(caveCell):
				validLayerArea = false
				break

		if not validLayerArea:
			continue

		addLandmark(cell, cave)
		for offset in cave.tileCoords:
			tileData.clear_resource(Vector2(cell) + offset)
		print("Layer %s, cave generated at %s" % [layerIndex + 1, cell])
		return

	push_warning("Could not place Archipelago cave in layer %s" % [layerIndex + 1])
	cave.free()

func isCellInProtectedCells(cell: Vector2i) -> bool:
	for protectedCell in CONSTARRC.PROTECTED_SPAWNS:
		if cell == Vector2i(protectedCell):
			return true
	return false


