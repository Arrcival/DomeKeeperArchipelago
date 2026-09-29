extends "res://content/map/Map.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

const ARCHIPELAGO_CAVE_SCENE: Resource = preload("res://mods-unpacked/Arrcival-Archipelago/content/cave/ArchipelagoCave.tscn")

func init(fromDeserialize: = false, defaultState := true):
	Data.TILE_ID_TO_STRING_MAP.merge({CONSTARRC.TILE_ARCHIPELAGO_SWITCH:CONSTARRC.ARCHIPELAGOSWITCH})
	Data.TILE_ID_TO_STRING_MAP.merge({CONSTARRC.TILE_CHAMBER:CONSTARRC.CHAMBER})
	super.init(fromDeserialize, defaultState)
	
	if not fromDeserialize:
		var clusterCenters = tileData.get_resource_cells_by_id(CONSTARRC.TILE_ARCHIPELAGO_SWITCH)
		if GameWorld.devMode or OS.is_debug_build():
			print("Tile AP switches :")
			print(clusterCenters)
		for tile in clusterCenters:
			addChamber(tile, getSceneForTileType(CONSTARRC.TILE_ARCHIPELAGO_SWITCH))
		
		clusterCenters = tileData.get_resource_cells_by_id(CONSTARRC.TILE_CHAMBER)
		if GameWorld.devMode or OS.is_debug_build():
			print("Tile AP chambers :")
			print(clusterCenters)
		for tile in clusterCenters:
			addChamber(tile, getSceneForTileType(CONSTARRC.TILE_CHAMBER))
		
		if GameWorld.devMode:
			addChamber(Vector2(0, 2), getSceneForTileType(CONSTARRC.TILE_ARCHIPELAGO_SWITCH))

func getSceneForTileType(tileType:int) -> PackedScene:
	if tileType == CONSTARRC.TILE_ARCHIPELAGO_SWITCH:
		return preload("res://mods-unpacked/Arrcival-Archipelago/content/switch/ArchipelagoSwitch.tscn")
	if tileType == CONSTARRC.TILE_CHAMBER:
		return preload("res://mods-unpacked/Arrcival-Archipelago/content/chamber/ArchipelagoChamber.tscn")
	return super.getSceneForTileType(tileType)

# Add one archipelago cave per accessible layer
func addCaves(minDistanceToCenter: = 10):
	super.addCaves(minDistanceToCenter)

	if not GameWorld.archipelago.isRHMode():
		return

	# TODO: alimenter le dict avec les nouvelles caves
	addArchipelagoCave(0)
	addArchipelagoCave(1)
	addArchipelagoCave(2)
	
	if GameWorld.devMode:
		return
	
	if GameWorld.archipelago.mapSize >= 1:
		addArchipelagoCave(3)
	if GameWorld.archipelago.mapSize >= 2:
		addArchipelagoCave(4)
		addArchipelagoCave(5)
	if GameWorld.archipelago.mapSize >= 3:
		addArchipelagoCave(6)


func addArchipelagoCave(biomeId: int):
	var cave: Node = ARCHIPELAGO_CAVE_SCENE.instantiate()
	addCaveWithSpawnProtections(cave, biomeId, 0)

# Same as addCave, but adds a protection so cave can't spawn near the dome
func addCaveWithSpawnProtections(cave, biomeIndex, minDistanceToCenter):
	var rand = RandomNumberGenerator.new()
	rand.seed = Level.levelSeed
	cave.updateUsedTileCoords()

	for _i in 25:
		var cells = tileData.get_biome_cells_by_index(biomeIndex)
		if cells.size() < cave.tileCoords.size():
			return 
		
		var cell = cells[rand.randi() % cells.size()]
		if abs(cell.x) < minDistanceToCenter:
			continue
			
		if isCellInProtectedCells(cell):
			print("tried generating AP cave but got skipped at : ", cell)
			continue
		
		if not tileData.is_area_free(cell, cave.tileCoords):
			continue


		addLandmark(cell, cave)
		for c in cave.tileCoords:
			var absCoord = Vector2(cell) + c
			tileData.clear_resource(absCoord)
		return

func isCellInProtectedCells(cell) -> bool:
	for protectedCell in CONSTARRC.PROTECTED_SPAWNS:
		if cell.x == protectedCell.x and cell.y == protectedCell.y:
			return true
	return false