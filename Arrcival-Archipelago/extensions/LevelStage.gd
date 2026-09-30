extends "res://stages/level/LevelStage.gd"

func _ready():
	super._ready()
	GameWorld.archipelago.onDeathFound.connect(self.makeUserLose)

func _process(deltaTime: float):
	super._process(deltaTime)

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
		Data.changeByInt("inventory.sand", resources["sand"])
	if resources["water"] > 0:
		Data.changeByInt("inventory.water", resources["water"])
	if resources["iron"] > 0:
		Data.changeByInt("inventory.iron", resources["iron"])

# Kill the user on death link with standard death behavior
func makeUserLose():
	GameWorld.archipelago.mark_death_link_death()
	Data.changeDomeHealth(-999999, "team1")

func beforeStart():
	super.beforeStart()
	if GameWorld.archipelago.isRHMode():
		GameWorld.archipelago.scoutUpgrades()

