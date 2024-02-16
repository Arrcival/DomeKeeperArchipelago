extends "res://content/map/generation/TileDataGenerator.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

const FIRSTLAYERID = 10

func init(archetype:MapArchetype, randSeed: = randi()):
	.init(archetype, GameWorld.archipelago.seedNumber)

func generate():
	.generate()
	
	if finishedSuccessful == false:
		return
		
	finishedSuccessful = false
	var tdResources = $TileData / Resources
	var tdBiomes = $TileData / Biomes


	if not GameWorld.devMode:
		generateSwitchesCoordinates(
			tdBiomes, 
			tdResources, 
			GameWorld.archipelago.switchesPerLayers,
			GameWorld.archipelago.seedNumber)

	finishedSuccessful = true

func generateSwitchesCoordinates(tdBiomes, tdResources, switchesPerLayers: Array, gen_seed: int) -> void:
	
	for i in switchesPerLayers.size():
		var biomeCells: Array = tdBiomes.get_used_cells_by_id(FIRSTLAYERID + i)
		if biomeCells.size() == 0:
			break
		var biomeCellsShuffled = Data.seedShuffle(biomeCells, gen_seed)

		var switchesGenerated: int = 0
		var array = []
		for cell in biomeCellsShuffled:
			var ressourceCell: int = tdResources.get_cell(cell.x, cell.y)
			if ressourceCell >= Data.TILE_DIRT_START && ressourceCell <= Data.TILE_DIRT_END:
				tdResources.set_cell(cell.x, cell.y, CONSTARRC.TILE_ARCHIPELAGO_SWITCH)
				GameWorld.archipelago.switches.append(cell)
				array.append(cell)
				switchesGenerated += 1
			if switchesGenerated >= switchesPerLayers[i]:
				break
		if OS.is_debug_build():
			print("Switches for layer " + str(i) + " : ")
			print(array)
