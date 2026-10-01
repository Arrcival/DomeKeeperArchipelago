extends "res://game/GameWorld.gd"

var chat # used for logging stuff from AP

var archipelago = load("res://mods-unpacked/Arrcival-Archipelago/content/archipelago/ArchipelagoData.gd").new()

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func init():
	super.init()
	if not archipelago.upgrade_received.is_connected(_on_archipelago_upgrade_received):
		archipelago.upgrade_received.connect(_on_archipelago_upgrade_received)
	# prevent randomizer to be on something the user hasn't unlocked
	# bruteforce unlock everything :/
	unlockEverything()

func _on_archipelago_upgrade_received(item_name: String) -> void:
	addUpgrade(item_name, "team1")

# Deathlink
# TODO: deathlink issue on ressurection: HP technically drops to 0
func handleGameLost(backendData:Dictionary = {}):
	super.handleGameLost(backendData)
	if not won:
		if not archipelago.consume_death_link_death():
			archipelago.send_death("The dome was destroyed...")


# Restart items given from AP
# They are given back in LevelStage
func levelInitialized():
	super.levelInitialized()
	if archipelago.isRHMode():
		archipelago.prepare_level()



func buyUpgrade(id: String, teamId: String, playerId: String):
	if not archipelago.isRHMode():
		return super.buyUpgrade(id, teamId, playerId)
	
	# preventing any crash from empty upgrades
	if id == "":
		return

	# Archipelago upgrades, default behavior
	if id.begins_with("team1.archipelago"):
		archipelago.submitUpgrade(id)

	# Usual upgrades
	if not CONSTARRC.is_upgrade_purchasable(id.to_lower()):
		return

	super.buyUpgrade(id, teamId, playerId)

func prepareLevelStart(levelStartData:LevelStartData):
	if levelStartData.loadout.modeId == CONST.MODE_ASSIGNMENTS:
		var assignment_name = levelStartData.loadout.modeConfig.get(CONST.MODE_CONFIG_ASSIGNMENT, "projectilehell")
		Level.levelSeed = archipelago.get_seed(assignment_name)
	elif levelStartData.loadout.modeId == CONST.MODE_RELICHUNT:
		Level.levelSeed = archipelago.get_seed()
	super.prepareLevelStart(levelStartData)
