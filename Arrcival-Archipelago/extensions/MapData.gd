extends "res://content/map/MapData.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func get_mineable_tile_coords() -> Array:
    var coords: = super.get_mineable_tile_coords()
    coords.append_array(get_resource_cells_by_id(CONSTARRC.TILE_ARCHIPELAGO_SWITCH))
    coords.append_array(get_resource_cells_by_id(CONSTARRC.TILE_CHAMBER))
    coords.append_array(get_resource_cells_by_id(CONSTARRC.TILE_CHEST))
    return coords