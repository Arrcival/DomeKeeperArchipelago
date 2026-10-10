class_name ArchipelagoTileManager

const CONSTARRC: GDScript = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var _slot_data: ArchipelagoSlotData
var _progression: ArchipelagoProgression

var _layers_per_distance: Array
var _layer_max_distances: Array[int] = []
var _cell_distances: Dictionary = {}

func setup(slot_data: ArchipelagoSlotData, progression: ArchipelagoProgression) -> void:
	_slot_data = slot_data
	_progression = progression

func generate_layers_per_distance(mineable_cells: Array):
	_layers_per_distance = []
	_layer_max_distances.clear()
	_cell_distances.clear()

	var layers_amount :int = _slot_data.get_layer_amount()
	var layers: Array = []
	if layers_amount <= 0:
		return layers

	for i in range(layers_amount):
		layers.append([])
		_layer_max_distances.append(-1)

	if mineable_cells.is_empty():
		_layers_per_distance = layers
		return layers

	var mineable_lookup: Dictionary = {}
	for cell in mineable_cells:
		mineable_lookup[Vector2i(cell)] = true

	# Flood-fill the mineable cells from the dome, moving only cardinally.
	var distances: Dictionary = {}
	var start: Vector2i = Vector2i.ZERO
	if mineable_lookup.has(start):
		var queue: Array[Vector2i] = [start]
		distances[start] = 0
		var queue_index: int = 0
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
				if mineable_lookup.has(neighbor) and not distances.has(neighbor):
					distances[neighbor] = distances[cell] + 1
					queue.append(neighbor)

	var max_distance: int = 0
	for distance in distances.values():
		max_distance = max(max_distance, distance)

	# Split the full reachable distance range evenly across the requested layers.
	# Cells disconnected from the dome have no path distance, so keep them in the
	# outermost layer rather than silently dropping them.
	for cell in mineable_cells:
		var coord: Vector2i = Vector2i(cell)
		var cell_distance: int = -1
		var layer_index: int = layers_amount - 1
		if distances.has(coord):
			cell_distance = distances[coord]
			layer_index = min(layers_amount - 1, int(cell_distance * layers_amount / (max_distance + 1)))
		_cell_distances[coord] = cell_distance
		layers[layer_index].append(coord)
		if cell_distance >= 0:
			_layer_max_distances[layer_index] = max(_layer_max_distances[layer_index], cell_distance)

	_layers_per_distance = layers.duplicate()
	print("@#@#@#@# Result : %s" % _layers_per_distance)

	if OS.is_debug_build():
		for i in range(len(_layers_per_distance)):
			print("@#@#@#@# Layer %s : %s" % [i, _layers_per_distance[i]])

func get_generated_layers() -> Array:
	return _layers_per_distance

func get_generated_layer_max_distances() -> Array[int]:
	return _layer_max_distances

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
	var mineable_layers = _progression.get_layer_unlocked_amount()
	if mineable_layers >= len(_layer_max_distances) - 1:
		return 999
	return _layer_max_distances[mineable_layers]

func update_max_depth_hud() -> void:
	var max_depth = get_maximum_depth()
	Data.apply("team1.archipelago.maxdepth", max_depth)