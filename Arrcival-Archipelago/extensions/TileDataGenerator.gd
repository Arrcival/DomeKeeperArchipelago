extends "res://content/map/generation/TileDataGenerator.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

const FIRSTLAYERID = 0

const archipelago_chamber_offset: = [Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)]

# extension 
func generate_resources(rand):

	_prepare_archipelago_generation()

	super.generate_resources(rand)

	print("@@@@ Generating archipelago water and switches")

	if not GameWorld.archipelago.is_relic_hunt():
		return


	_generate_extra_water()

	GameWorld.archipelago.clear_switch_locations()

	if not GameWorld.devMode:
		generate_switches_coordinates(GameWorld.archipelago.get_switches_per_layer())
	print("@@@@ Done generating archipelago ressources")

func _prepare_archipelago_generation():
	GameWorld.archipelago.reset()

	var mineable_tiles :Array = []
	for i in range(0, 5):
		mineable_tiles.append_array(_mapData.get_hardness_cells_by_grade(i))

	GameWorld.archipelago.generate_layers(mineable_tiles)

func _generate_extra_water():
	var firstBiomeCells: Array = _mapData.get_biome_cells_by_index(FIRSTLAYERID)
	if firstBiomeCells.size() > 0:
		var biomeCellsShuffled = Data.seedShuffle(firstBiomeCells, gen_seed)
		for cell in biomeCellsShuffled:
			var ressourceCell: int = _mapData.get_resourcev(cell)
			if ressourceCell >= Data.TILE_DIRT_START && ressourceCell <= Data.TILE_DIRT_START + Data.HARDNESS_VERY_HARD:
				_mapData.set_resourcev(cell, Data.TILE_WATER)
				print("@@@@@@@@ Added water on " + str(cell.x) + ", " + str(cell.y))
				break

# extension
func generate_gadget_chambers():
	super.generate_gadget_chambers()
	print("@@@@ Generating AP chambers")
	
	var layers_per_distance :Array = GameWorld.archipelago.get_generated_layers() # Array of array
	if GameWorld.archipelago.is_relic_hunt():
		var biomes = 3 if GameWorld.devMode else layers_per_distance.size()
		for i in range(biomes):
			var layerCells: Array = layers_per_distance[i].duplicate()
			_try_placing_chamber(layerCells)

	else: # Guild assignments
		for i in range(2):
			var everyCells: Array = _mapData.get_resource_cells_by_id(Data.TILE_DIRT_START)
			_try_placing_chamber(everyCells)
	print("@@@@ Done generating AP chambers")

func _try_placing_chamber(cells: Array) -> bool:
	var cellsShuffled = Data.seedShuffle(cells, gen_seed)
	for cell in cellsShuffled:
		var coords = _get_chamber_coords(Vector2(cell))
		var placed = tryPlace(CONSTARRC.TILE_CHAMBER, coords)
		if placed:
			# keep the top left, flag the other are blocked but not chamber
			for i in range(1, coords.size()):
				_mapData.set_resourcev(coords[i], Data.TILE_DIRT_MARK_BLOCKED_FOR_CHAMBER)
			#print("@@@@@@@@ Generated AP gadget chamber on " + str(cell))
			return true
	return false

func _get_chamber_coords(coord: Vector2) -> Array:
	var coords := []
	for c in archipelago_chamber_offset:
		coords.append(c + coord)
	return coords

# extension
func tryPlace(cellType: int, cells: Array) -> bool:
	for cell in cells:
		var resourceCell: int = _mapData.get_resourcev(cell)
		if resourceCell == CONSTARRC.TILE_ARCHIPELAGO_SWITCH or resourceCell == CONSTARRC.TILE_CHAMBER or resourceCell == Data.TILE_DIRT_MARK_BLOCKED_FOR_CHAMBER:
			return false

	return super.tryPlace(cellType, cells)

func generate_switches_coordinates(switchesPerLayer: Array) -> void:
	print("@@@@@@@@ Generating AP switches")
	print("@@@@@@@@ Switch layers to be generated : " + str(switchesPerLayer))

	var layers_per_distance :Array = GameWorld.archipelago.get_generated_layers() # Array of array
	print("@@@@@@@@ %s layers found" % layers_per_distance.size())
	for i in layers_per_distance.size():
		var layer_cells :Array = layers_per_distance[i]
		print("@@@@@@@@@@@@ Generating switches for layer %s, found %s cells" % [i, layer_cells.size()])
		if layer_cells.is_empty():
			printerr("@@@@@@@@@@@@ No cells found for layer %s" % i)
			break

		var shuffled_cells: Array = Data.seedShuffle(layer_cells, gen_seed)

		var switchesGenerated: int = 0
		var array := []
		for cell in shuffled_cells:
			var ressourceCell: int = _mapData.get_resourcev(Vector2(cell.x, cell.y))
			if ressourceCell >= Data.TILE_DIRT_START && ressourceCell <= Data.TILE_DIRT_START + Data.HARDNESS_VERY_HARD:

				#if OS.is_debug_build() and switchesGenerated == 0 and i == 0:
				#	cell.x = 0
				#	cell.y = 2
				if not tryPlace(CONSTARRC.TILE_ARCHIPELAGO_SWITCH, [cell]):
					continue
				array.append(cell)
				#print("@@@@@@@@@@@@ Generated on layer " + str(i) + " a switch at " + str(cell))
				switchesGenerated += 1
			if switchesGenerated >= switchesPerLayer[i]:
				break
		GameWorld.archipelago.add_switch_locations(array)
		if OS.is_debug_build():
			print("@@@@@@@@ Switches for layer %s :" % i)
			print("@@@@@@@@ %s" % str(array))
	print("@@@@@@@@ Done enerating AP switches")
