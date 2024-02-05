extends "res://content/map/Map.gd"


const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func getSceneForTileType(tileType:int)->PackedScene:
	if tileType == CONSTARRC.TILE_ARCHIPELAGO_SWITCH:
		return preload("res://mods-unpacked/Arrcival-Archipelago/content/switch/ArchipelagoSwitch.tscn")
	return .getSceneForTileType(tileType)

func init(fromDeserialize: = false):
	.init(fromDeserialize)
	
	GameWorld.archipelago.switches = []
	
	
	
	var archipelagoSwitches = tileData.get_resource_cells_by_id(CONSTARRC.TILE_ARCHIPELAGO_SWITCH)
	if GameWorld.devMode or OS.is_debug_build():
		print(archipelagoSwitches)
	for tile in archipelagoSwitches:
		addChamber(tile, getSceneForTileType(CONSTARRC.TILE_ARCHIPELAGO_SWITCH))
	if GameWorld.devMode:
		addChamber(Vector2(0, 2), getSceneForTileType(CONSTARRC.TILE_ARCHIPELAGO_SWITCH))
	
