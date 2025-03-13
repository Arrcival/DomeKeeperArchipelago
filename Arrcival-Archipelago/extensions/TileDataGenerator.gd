extends "res://content/map/generation/TileDataGenerator.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

const FIRSTLAYERID = 0

func generate_resources(rand):
	super.generate_resources(rand)

	if not GameWorld.archipelago.isRHMode():
		return

	var firstBiomeCells: Array = $MapData.get_biome_cells_by_index(FIRSTLAYERID)
	if firstBiomeCells.size() > 0:
		var biomeCellsShuffled = Data.seedShuffle(firstBiomeCells, gen_seed)
		for cell in biomeCellsShuffled:
			var ressourceCell: int = $MapData.get_resourcev(cell)
			if ressourceCell >= Data.TILE_DIRT_START && ressourceCell <= Data.TILE_DIRT_START + Data.HARDNESS_VERY_HARD:
				$MapData.set_resourcev(cell, Data.TILE_WATER)
				print("Added water on " + str(cell.x) + ", " + str(cell.y))
				break

	GameWorld.archipelago.switchesLocation.clear()
	if not GameWorld.devMode:
		generateSwitchesCoordinates(GameWorld.archipelago.switchesPerLayers)

func generate_gadget_chambers():
	super.generate_gadget_chambers()
	
	if GameWorld.archipelago.isRHMode():
		var biomes = 3 + GameWorld.archipelago.mapSize
		for i in range(biomes):
			var biomeCells: Array = $MapData.get_biome_cells_by_index(FIRSTLAYERID + i)
			var biomeCellsShuffled = Data.seedShuffle(biomeCells, gen_seed)
			for cell in biomeCellsShuffled:
				var placed = tryPlace(CONSTARRC.TILE_CHAMBER, [cell])
				if placed:
					break
	else:
		for i in range(2):
			var everyCells: Array = $MapData.get_resource_cells_by_id(Data.TILE_DIRT_START)
			var cellsShuffled = Data.seedShuffle(everyCells, gen_seed)
			for cell in cellsShuffled:
				var placed = tryPlace(CONSTARRC.TILE_CHAMBER, [cell])
				if placed:
					break
		

func generateSwitchesCoordinates(switchesPerLayers: Array) -> void:
	
	for i in switchesPerLayers.size():
		var biomeCells: Array[Vector2i] = $MapData.get_biome_cells_by_index(FIRSTLAYERID + i)
		if biomeCells.size() == 0:
			break
		var biomeCellsShuffled: Array[Vector2i] = Data.seedShuffle(biomeCells, gen_seed)

		var switchesGenerated: int = 0
		var array = []
		for cell in biomeCellsShuffled:
			var ressourceCell: int = $MapData.get_resourcev(Vector2(cell.x, cell.y))
			if ressourceCell >= Data.TILE_DIRT_START && ressourceCell <= Data.TILE_DIRT_START + Data.HARDNESS_VERY_HARD:

				#if OS.is_debug_build() and switchesGenerated == 0 and i == 0:
				#	cell.x = 0
				#	cell.y = 2

				$MapData.set_resourcev(cell, CONSTARRC.TILE_ARCHIPELAGO_SWITCH)
				array.append(cell)
				switchesGenerated += 1
			if switchesGenerated >= switchesPerLayers[i]:
				break
		GameWorld.archipelago.switchesLocation.append(array)
		if OS.is_debug_build():
			print("Switches for layer " + str(i) + " : ")
			print(array)
