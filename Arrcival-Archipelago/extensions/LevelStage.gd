extends "res://stages/level/LevelStage.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")
const AP_KEY_SCENE: PackedScene = preload("res://mods-unpacked/Arrcival-Archipelago/content/key/APKeyDrop.tscn")

func _ready():
	super._ready()
	GameWorld.archipelago.onDeathFound.connect(self.makeUserLose)

func _process(deltaTime: float):
	super._process(deltaTime)
	_spawn_pending_archipelago_keys()

	# Process upgrade in frame per frame basis
	# Unwinds the upgrades retrieved to avoid locks
	var upgrades: Array = GameWorld.archipelago.checkUpgrades()
	if upgrades.size() > 0:
		var tree = get_tree()
		if tree != null:
			var nodes = tree.get_nodes_in_group("techpanel")
			if nodes != null and nodes.size() > 0:
				for node in nodes:
					if upgrades.has(node.techId):
						node.reactivate()

	# Apply resources received since the previous frame.
	var resources: Dictionary = GameWorld.archipelago.consume_resource_deltas()
	if resources["sand"] > 0:
		Data.changeByInt("team1.inventory.sand", resources["sand"])
	if resources["water"] > 0:
		Data.changeByInt("team1.inventory.water", resources["water"])
	if resources["iron"] > 0:
		Data.changeByInt("team1.inventory.iron", resources["iron"])

# Spawn received keys on the server. The key's AP item ID maps directly to
# the chest location index: key 4242130 opens chest location 4243200.
func _spawn_pending_archipelago_keys() -> void:
	if not GameWorld.archipelago.is_relic_hunt() or not multiplayer.is_server():
		return
	if not is_instance_valid(Level.drops):
		return

	for key_ap_id: int in GameWorld.archipelago.get_pending_key_ids():
		var chest_index: int = key_ap_id - 4242130
		var chest_location_id: int = CONSTARRC.CHEST_LOCATION_ID + chest_index

		# Already opened in this AP session: do not spawn a useless key.
		if GameWorld.archipelago.has_checked_location(chest_location_id):
			GameWorld.archipelago.consume_pending_key(key_ap_id)
			continue

		var dome = Level.domesByTeamId.get("team1")
		if not is_instance_valid(dome):
			continue

		var key_number: int = chest_index + 1
		var key_drop = Level.drops.network_spawn({
			"type": CONSTARRC.AP_KEY,
			"position": dome.global_position + Vector2(0, 16),
			"carriers": [],
			"team": "team1",
		})
		if is_instance_valid(key_drop):
			key_drop.set_number(key_number)
			GameWorld.archipelago.consume_pending_key(key_ap_id)

# Kill the user on death link with standard death behavior
func makeUserLose():
	GameWorld.archipelago.mark_death_link_death()
	Data.changeDomeHealth(-999999, "team1")

func beforeStart():
	super.beforeStart()
	if GameWorld.archipelago.is_relic_hunt():
		GameWorld.archipelago.scoutUpgrades()

