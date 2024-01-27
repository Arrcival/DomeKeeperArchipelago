extends "res://content/map/generation/TileDataGenerator.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func init(archetype:MapArchetype, randSeed: = randi()):
	.init(archetype, GameWorld.archipelago.client.slotSeed)

func generate():
	.generate()
	
	if finishedSuccessful == false:
		return
		
	finishedSuccessful = false
	var tdResources = $TileData / Resources
	var tdBiomes = $TileData / Biomes
		
	var cells = []
	for i in range(10, 20):
		cells += tdBiomes.get_used_cells_by_id(i)
		
	var switchCoordinates = generateSwitchesCoordinates(tdResources, cells, GameWorld.archipelago.TOTAL_SWITCHES_AMOUNT)
	for switchCoordinate in switchCoordinates:
		tdResources.set_cell(switchCoordinate.x, switchCoordinate.y, CONSTARRC.TILE_ARCHIPELAGO_SWITCH)

	finishedSuccessful = true

func generateSwitchesCoordinates(tdResources, cells: Array, amount: int) -> Array:
	var switchCoordinates = []
	if cells.size() > 0:
		var allCells = Data.seedShuffle(cells, GameWorld.archipelago.client.slotSeed)

		var switchesGenerated = 0
		for cell in allCells:
			var ressourceCell = tdResources.get_cellv(cell)
			if ressourceCell >= Data.TILE_DIRT_START && ressourceCell <= Data.TILE_DIRT_END:
				switchCoordinates.append(cell)
				#tdResources.set_cell(cell.x, cell.y, CONSTARRC.TILE_ARCHIPELAGO_SWITCH)
				switchesGenerated += 1
			if switchesGenerated >= amount:
				break
	return switchCoordinates
