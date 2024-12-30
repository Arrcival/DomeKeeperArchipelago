extends Map

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")
const TILE_SCENE_EDITED = preload("res://mods-unpacked/Arrcival-Archipelago/content/tile/Tile2.tscn")

const ARCHIPELAGO_CAVE_SCENE: Resource = preload("res://mods-unpacked/Arrcival-Archipelago/content/cave/ArchipelagoCave.tscn")

func init(fromDeserialize: = false, defaultState := true):
	Data.TILE_ID_TO_STRING_MAP.merge({CONSTARRC.TILE_ARCHIPELAGO_SWITCH:CONSTARRC.ARCHIPELAGOSWITCH})
	super.init(fromDeserialize, defaultState)
	
	if not fromDeserialize:
		var clusterCenters = tileData.get_resource_cells_by_id(CONSTARRC.TILE_ARCHIPELAGO_SWITCH)
		if GameWorld.devMode or OS.is_debug_build():
			print(clusterCenters)
		for tile in clusterCenters:
			addChamber(tile, getSceneForTileType(CONSTARRC.TILE_ARCHIPELAGO_SWITCH))
		if GameWorld.devMode:
			addChamber(Vector2(0, 2), getSceneForTileType(CONSTARRC.TILE_ARCHIPELAGO_SWITCH))
	
func getSceneForTileType(tileType:int)->PackedScene:
	if tileType == CONSTARRC.TILE_ARCHIPELAGO_SWITCH:
		return preload("res://mods-unpacked/Arrcival-Archipelago/content/switch/ArchipelagoSwitch.tscn")
	return super.getSceneForTileType(tileType)

func revealTile(coord:Vector2):
	var invalids := []
	if tileRevealedListeners.has(coord):
		for listener in tileRevealedListeners[coord]:
			if is_instance_valid(listener):
				listener.tileRevealed(coord)
			else:
				invalids.append(listener)
		for invalid in invalids:
			tileRevealedListeners.erase(invalid)
	
	var typeId:int = tileData.get_resource(coord.x, coord.y)
	if typeId == Data.TILE_EMPTY:
		return
	
	if tiles.has(coord):
		return
	
	var tile = TILE_SCENE_EDITED.instantiate()
	var biomeId:int = tileData.get_biome(coord.x, coord.y)
	tile.layer = biomeId
	tile.biome = biomes[tile.layer]
	tile.position = coord * GameWorld.TILE_SIZE
	tile.coord = coord
		
	tile.hardness = tileData.get_hardness(coord.x, coord.y)

	tile.type = Data.TILE_ID_TO_STRING_MAP.get(typeId, "dirt")
	match tile.type:
		CONST.IRON:
			tile.richness = Data.ofOr("map.ironrichness", 2)
			revealTileVisually(coord)
		CONST.SAND:
			tile.richness = Data.ofOr("map.cobaltrichness", 2)
			revealTileVisually(coord)
		CONST.WATER:
			tile.richness = Data.ofOr("map.waterrichness", 2.5)
			revealTileVisually(coord)
	tiles[coord] = tile 
	
	if tilesByType.has(tile.type):
		tilesByType[tile.type].append(tile)
	tile.connect("destroyed", Callable(self, "destroyTile").bind(tile))
	
	tiles_node.add_child(tile)

	# Allow border tiles to fade correctly at edges of the map
	visibleTileCoords[coord] = typeId


func getBiomeValueByCoord(_coord:Vector2):
	return tileData.get_biomev(_coord)

# Add one archipelago cave per accessible layer
func generateCaves(minDistanceToCenter: = 10):
	super.generateCaves()

	if not GameWorld.archipelago.isRHMode():
		return

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
		
		if OS.is_debug_build():
			print("Added cave at : ", cell)
		
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
