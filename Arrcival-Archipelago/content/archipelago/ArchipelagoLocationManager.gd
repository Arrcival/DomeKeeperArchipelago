class_name ArchipelagoLocationManager

const FIRST_SWITCH_ID: int = 4243301
const LAYER_OFFSET: int = 100

const LOCATION_FIRST_CAVE_ID: int = 4243020
const LOCATION_FIRST_CHAMBER_SYNC_ID: int = 4243090
const LOCATION_FIRST_CHAMBER_ASYNC_ID: int = 4243100
const ASSIGNMENTS_AMOUNT: int = 25

var location_ids: Dictionary = {
	"archipelagoupgradeiron1": 4243001,
	"archipelagoupgradeiron2": 4243002,
	"archipelagoupgradeiron3": 4243003,
	"archipelagoupgradeiron4": 4243004,
	"archipelagoupgradewater1": 4243005,
	"archipelagoupgradewater2": 4243006,
	"archipelagoupgradewater3": 4243007,
	"archipelagoupgradewater4": 4243008,
	"archipelagoupgradeironwater1": 4243009,
	"archipelagoupgradeironwater2": 4243010,
	"archipelagoupgradeironwater3": 4243011,
	"archipelagoupgradeironwater4": 4243012,
}

var cave_location_id: int = LOCATION_FIRST_CAVE_ID
var chamber_sync_location_id: int = LOCATION_FIRST_CHAMBER_SYNC_ID
var chamber_async_location_id: int = LOCATION_FIRST_CHAMBER_ASYNC_ID
var chambers_generated: int = 0

var switches_found: Array[int] = []
var switches_location: Array = []

var location_scouts: Dictionary = {
	4243001: "",
	4243002: "",
	4243003: "",
	4243004: "",
	4243005: "",
	4243006: "",
	4243007: "",
	4243008: "",
	4243009: "",
	4243010: "",
	4243011: "",
	4243012: "",
}

func reset() -> void:
	switches_found.clear()
	cave_location_id = LOCATION_FIRST_CAVE_ID
	chamber_sync_location_id = LOCATION_FIRST_CHAMBER_SYNC_ID
	chamber_async_location_id = LOCATION_FIRST_CHAMBER_ASYNC_ID
	chambers_generated = 0

# Clears generated counters and map/session-specific location data.
func reset_all() -> void:
	reset()
	switches_location.clear()
	for location_id: int in location_scouts:
		location_scouts[location_id] = ""

func next_cave_location() -> int:
	var location_id := cave_location_id
	cave_location_id += 1
	return location_id

func next_chamber_location(is_relic_hunt: bool, assignment_id: int = 0) -> int:
	if is_relic_hunt:
		var location_id := chamber_sync_location_id
		chamber_sync_location_id += 1
		return location_id

	chamber_async_location_id = LOCATION_FIRST_CHAMBER_ASYNC_ID + assignment_id
	var location_id := chamber_async_location_id + chambers_generated * ASSIGNMENTS_AMOUNT
	chambers_generated += 1
	return location_id

func get_upgrade_location(upgrade_name: String) -> int:
	var upgrade = upgrade_name
	if upgrade.contains("team1."):
		upgrade = upgrade_name.split("team1.")[1]

	return int(location_ids.get(upgrade, -1))

func get_scout_description(location_id: int) -> String:
	return str(location_scouts.get(location_id, ""))

func get_switch_location(position: Vector2i) -> int:
	for layer_index: int in range(switches_location.size()):
		var layer_switches: Array[Vector2i]
		layer_switches.assign(switches_location[layer_index])
		var switch_index := layer_switches.find(position)
		if switch_index == -1:
			continue

		var location_id := FIRST_SWITCH_ID + layer_index * LAYER_OFFSET + switch_index
		if switches_found.has(location_id):
			return -1
		switches_found.append(location_id)
		return location_id
	return -1

func receive_scouts(network_items: Array) -> void:
	for item: Variant in network_items:
		if location_scouts.has(item.locationId):
			location_scouts[item.locationId] = item.displayUnlock()

func get_scout_location_ids() -> Array:
	return location_scouts.keys()
