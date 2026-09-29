extends "res://content/map/generation/TileDataGenerator.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

const FIRSTLAYERID = 0

# TODO: Changer la logique de biome en distance to dome w/o bedrock
func generate_resources(rand):
	super.generate_resources(rand)

	print("@@@@ Generating archipelago water and switches")

	if not GameWorld.archipelago.isRHMode():
		return

	var firstBiomeCells: Array = _mapData.get_biome_cells_by_index(FIRSTLAYERID)
	if firstBiomeCells.size() > 0:
		var biomeCellsShuffled = Data.seedShuffle(firstBiomeCells, gen_seed)
		for cell in biomeCellsShuffled:
			var ressourceCell: int = _mapData.get_resourcev(cell)
			if ressourceCell >= Data.TILE_DIRT_START && ressourceCell <= Data.TILE_DIRT_START + Data.HARDNESS_VERY_HARD:
				_mapData.set_resourcev(cell, Data.TILE_WATER)
				print("@@@@@@@@ Added water on " + str(cell.x) + ", " + str(cell.y))
				break

	GameWorld.archipelago.locations.switches_location.clear()
	if not GameWorld.devMode:
		generate_switches_coordinates(GameWorld.archipelago.slotData.switchesPerLayer)
	print("@@@@ Done generating archipelago ressources")

func generate_gadget_chambers():
	super.generate_gadget_chambers()
	print("@@@@ Generating AP chambers")
	
	if GameWorld.archipelago.isRHMode():
		var biomes = 3 if GameWorld.devMode else len(GameWorld.archipelago.slotData.switchesPerLayer)
		for i in range(biomes):
			var biomeCells: Array = _mapData.get_biome_cells_by_index(FIRSTLAYERID + i)
			var biomeCellsShuffled = Data.seedShuffle(biomeCells, gen_seed)
			for cell in biomeCellsShuffled:
				var placed = tryPlace(CONSTARRC.TILE_CHAMBER, [cell])
				if placed:
					print("@@@@@@@@ Generated RH gadget chamber on " + str(cell))
					break
	else: # Guild assignments
		for i in range(2):
			var everyCells: Array = _mapData.get_resource_cells_by_id(Data.TILE_DIRT_START)
			var cellsShuffled = Data.seedShuffle(everyCells, gen_seed)
			for cell in cellsShuffled:
				var placed = tryPlace(CONSTARRC.TILE_CHAMBER, [cell])
				if placed:
					print("@@@@@@@@ Generated GA gadget chamber on " + str(cell))
					break
	print("@@@@ Done generating AP chambers")
		

func generate_switches_coordinates(switchesPerLayer: Array) -> void:
	print("@@@@@@@@ Generating AP switches")
	print("@@@@@@@@ Switch layers to be generated : " + str(switchesPerLayer))

	for i in switchesPerLayer.size():
		var biomeCells: Array[Vector2i] = _mapData.get_biome_cells_by_index(FIRSTLAYERID + i)
		if biomeCells.size() == 0:
			break
		var biomeCellsShuffled: Array[Vector2i] = Data.seedShuffle(biomeCells, gen_seed)

		var switchesGenerated: int = 0
		var array = []
		for cell in biomeCellsShuffled:
			var ressourceCell: int = _mapData.get_resourcev(Vector2(cell.x, cell.y))
			if ressourceCell >= Data.TILE_DIRT_START && ressourceCell <= Data.TILE_DIRT_START + Data.HARDNESS_VERY_HARD:

				#if OS.is_debug_build() and switchesGenerated == 0 and i == 0:
				#	cell.x = 0
				#	cell.y = 2

				_mapData.set_resourcev(cell, CONSTARRC.TILE_ARCHIPELAGO_SWITCH)
				array.append(cell)
				print("@@@@@@@@@@@@ Generated on layer " + str(i) + " a switch at " + str(cell))
				switchesGenerated += 1
			if switchesGenerated >= switchesPerLayer[i]:
				break
		GameWorld.archipelago.locations.switches_location.append(array)
		if OS.is_debug_build():
			print("@@@@@@@@ witches for layer " + str(i) + " : ")
			print(array)
	print("@@@@@@@@ Done enerating AP switches")
