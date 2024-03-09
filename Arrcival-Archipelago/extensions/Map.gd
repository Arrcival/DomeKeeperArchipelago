extends "res://content/map/Map.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")
const TILE_SCENE_EDITED = preload("res://mods-unpacked/Arrcival-Archipelago/content/tile/Tile.tscn")

const ARCHIPELAGO_CAVE_SCENE: Resource = preload("res://mods-unpacked/Arrcival-Archipelago/content/cave/ArchipelagoCave.tscn")

func init(fromDeserialize: = false):
	TYPE_MAP.merge({CONSTARRC.TILE_ARCHIPELAGO_SWITCH:CONSTARRC.ARCHIPELAGOSWITCH})
	.init(fromDeserialize)
	Data.apply("map.totaltiles", Level.map.tileData().get_remaining_mineable_tile_count())
	
	if not fromDeserialize:
		var archipelagoSwitches = tileData.get_resource_cells_by_id(CONSTARRC.TILE_ARCHIPELAGO_SWITCH)
		if GameWorld.devMode or OS.is_debug_build():
			print(archipelagoSwitches)
		for tile in archipelagoSwitches:
			addChamber(tile, getSceneForTileType(CONSTARRC.TILE_ARCHIPELAGO_SWITCH))
		if GameWorld.devMode:
			addChamber(Vector2(0, 2), getSceneForTileType(CONSTARRC.TILE_ARCHIPELAGO_SWITCH))
	
func getSceneForTileType(tileType:int)->PackedScene:
	if tileType == CONSTARRC.TILE_ARCHIPELAGO_SWITCH:
		return preload("res://mods-unpacked/Arrcival-Archipelago/content/switch/ArchipelagoSwitch.tscn")
	return .getSceneForTileType(tileType)

func revealTile(coord:Vector2):
	var typeId:int = tileData.get_resource(coord.x, coord.y)
	if typeId == Data.TILE_EMPTY:
		return 
	
	if tiles.has(coord):
		return 
	
	if typeId == Data.TILE_CAVE:
		onTileRemoved(coord)
	else :
		var tile = TILE_SCENE_EDITED.instance()
		var biomeId:int = tileData.get_biome(coord.x, coord.y)
		tile.layer = biomeId
		tile.biome = biomes[tile.layer]
		tile.position = coord * GameWorld.TILE_SIZE
		tile.coord = coord
		if coord.y == - 1 and coord.x != 0:
			tile.visible = false
		tile.hardness = tileData.get_hardness(coord.x, coord.y)
		
		tile.type = TYPE_MAP.get(typeId, "dirt")
		match tile.type:
			CONST.IRON:
				tile.richness = 2
				revealTileVisual(coord)
			CONST.SAND:
				tile.richness = 2.0
				revealTileVisual(coord)
			CONST.WATER:
				tile.richness = 2.5
				revealTileVisual(coord)
		tiles[coord] = tile
		
		if tilesByType.has(tile.type):
			tilesByType[tile.type].append(tile)
		tile.connect("destroyed", self, "destroyTile", [tile])
		
		if futureRoots.has(coord):
			futureRoots.erase(coord)
			tile.root()
		
		tiles_node.add_child(tile)

	
	visibleTileCoords[coord] = null
	
	var invalids: = []
	if tileRevealedListeners.has(coord):
		for listener in tileRevealedListeners[coord]:
			if is_instance_valid(listener):
				listener.tileRevealed(coord)
			else :
				invalids.append(listener)
		for invalid in invalids:
			tileRevealedListeners.erase(invalid)

func getBiomeValueByCoord(_coord:Vector2):
	return tileData.get_biomev(_coord)

func generateCaves(minDistanceToCenter: = 10):
	.generateCaves()

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
	var cave: Node = ARCHIPELAGO_CAVE_SCENE.instance()
	addCave(cave, biomeId, 0)
	
