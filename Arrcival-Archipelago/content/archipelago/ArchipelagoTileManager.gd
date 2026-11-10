class_name ArchipelagoTileManager

const CONSTARRC: GDScript = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")
const ArchipelagoSlotData = preload("res://mods-unpacked/Arrcival-Archipelago/content/archipelago/ArchipelagoSlotData.gd")

var _slot_data: ArchipelagoSlotData
var _layer_unlock_getter: Callable

var _layers_per_distance: Array = []
var _cell_distances: Dictionary = {}

func setup(slot_data: ArchipelagoSlotData, layer_unlock_getter: Callable) -> void:
	_slot_data = slot_data
	_layer_unlock_getter = layer_unlock_getter

# AI assisted
func generate_layers_by_biome(biome_cells_by_layer: Array) -> Array:
	_layers_per_distance.clear()
	_cell_distances.clear()

	var layers_amount: int = _slot_data.get_layer_amount()
	if layers_amount <= 0:
		return _layers_per_distance

	for _i in range(layers_amount):
		_layers_per_distance.append([])

	var biome_by_cell: Dictionary = {}
	var path_lookup: Dictionary = {}
	for biome_index in range(biome_cells_by_layer.size()):
		for cell in biome_cells_by_layer[biome_index]:
			var coord := Vector2i(cell)
			biome_by_cell[coord] = biome_index
			path_lookup[coord] = true

	# Protected spawn tiles are traversable but aren't assigned to a biome layer
	for spawn in CONSTARRC.PROTECTED_SPAWNS:
		path_lookup[Vector2i(spawn)] = true

	# Flood-fill using the lowest possible maximum biome index along each route
	# A tile behind a higher-biome bottleneck therefore inherits that bottleneck's layer
	var required_biome: Dictionary = {}
	var start := Vector2i.ZERO
	if path_lookup.has(start):
		var queue: Array[Vector2i] = [start]
		required_biome[start] = max(0, biome_by_cell.get(start, 0))
		var queue_index := 0
		var directions: Array[Vector2i] = [
			Vector2i(1, 0),
			Vector2i(-1, 0),
			Vector2i(0, 1),
			Vector2i(0, -1),
		]

		while queue_index < queue.size():
			var cell: Vector2i = queue[queue_index]
			queue_index += 1
			for direction in directions:
				var neighbor: Vector2i = cell + direction
				if not path_lookup.has(neighbor):
					continue
				var neighbor_biome: int = biome_by_cell.get(neighbor, -1)
				var candidate: int = max(required_biome[cell], neighbor_biome)
				if required_biome.has(neighbor) and required_biome[neighbor] <= candidate:
					continue
				required_biome[neighbor] = candidate
				queue.append(neighbor)

	for biome_index in range(biome_cells_by_layer.size()):
		for cell in biome_cells_by_layer[biome_index]:
			var coord := Vector2i(cell)
			if CONSTARRC.PROTECTED_SPAWNS.has(Vector2(coord)):
				continue

			# Unreachable tiles stay locked until the outermost layer is available
			# means 1,0 layer 1   2,0 layer 2   3,0 layer 1 is flagged as layer 2
			var required_layer: int = layers_amount - 1
			if required_biome.has(coord):
				required_layer = min(layers_amount - 1, required_biome[coord])
				if required_biome[coord] > biome_index:
					print("@#@#@#@# Tile %s moved from biome layer %s to layer %s; reaching it requires traversing biome %s." % [
						coord, biome_index, required_layer, required_biome[coord]
					])
			_layers_per_distance[required_layer].append(coord)
			_cell_distances[coord] = required_layer

	print("@#@#@#@# Result : %s" % _layers_per_distance)
	if OS.is_debug_build():
		for i in range(_layers_per_distance.size()):
			print("@#@#@#@# Layer %s : %s" % [i, _layers_per_distance[i]])

	return _layers_per_distance


func get_generated_layers() -> Array:
	return _layers_per_distance

func get_cell_distance(coord: Vector2) -> int:
	return _cell_distances.get(Vector2i(coord), -1)

func can_tile_be_mined(distance: int) -> bool:
	if _slot_data.is_guild_assignment():
		return true

	var max_depth = get_maximum_depth()
	if distance <= max_depth:
		return true
	return false

func get_maximum_depth() -> int:
	var mineable_layers: int = _layer_unlock_getter.call()
	if _layers_per_distance.is_empty() or mineable_layers >= _layers_per_distance.size() - 1:
		return 999
	return max(0, mineable_layers)

func update_max_depth_hud() -> void:
	var max_depth = get_maximum_depth()
	Data.apply("team1.archipelago.maxdepth", max_depth)