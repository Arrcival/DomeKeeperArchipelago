extends "res://stages/loadout/MultiplayerloadoutStage.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var json = JSON.new()

var keeper: Keeper

func build(data: Array):
	super.build(data)

	#var landingSequence: Node = get_node("CurrentStage/LandingSequence")
	#if landingSequence and GameWorld.archipelago.isRHMode():
	#	Level.levelSeed = GameWorld.archipelago.get_seed(get_assignment_name())
	#	return

	#var player1keeper = find_child("player1")
	#networkChangeKeeper(player1keeper, "keeper1-skin0")

	domeSelected(Data.loadoutDomes[GameWorld.archipelago.domeSlot], "team1", false)
	primaryGadgetSelected(Data.loadoutGadgets[GameWorld.archipelago.domeGadgetSlot], "team1", false)
	difficultySelected([-2, -1, 0, 2][GameWorld.archipelago.difficulty], "team1", false)
	mapSizeSelected(getMapSizeName(GameWorld.archipelago.mapSize))
	#manageAssignments()
	desactivate_keepers()
	desactivate_domes()
	desactivate_gadgets()
	desactivate_mapsizes()
	desactivate_difficulties()
	desactivate_modifiers()

#extending
func spawn_keeper(loadout_keeper: LoadoutKeeper) -> void:
	if multiplayer.is_server() and loadout_keeper.playerId == "player1":
		loadout_keeper.keeperId = "keeper" + str(GameWorld.archipelago.keeperSlot + 1)
		loadout_keeper.skinId = "skin0"

	super.spawn_keeper(loadout_keeper)


func desactivate_keepers():
	if not GameWorld.archipelago.isRHMode():
		return
	var kc = find_child("KeeperContainers")
	for i in range(4):
		if i == GameWorld.archipelago.keeperSlot:
			continue

		var keeperBox :Node = kc.get_child(i) # Container of keeper

		var keeperSkins: GridContainer = keeperBox.get_child(2) # Grid container of KeeperSelect scene
		for keeperChild in keeperSkins.get_children():
			keeperChild.set_enabled(false)

func fillGameModes():
	super.fillGameModes()
	var node: VBoxContainer = find_child("GameModeContainers")
	if GameWorld.archipelago.isRHMode():
		node.get_child(0).useHit(null)
	else:
		node.get_child(1).useHit(null)

	node.get_child(0).set_enabled(false) # RH
	node.get_child(1).set_enabled(false) # GA
	node.get_child(2).set_enabled(false) # Prestige


func desactivate_domes():
	if not GameWorld.archipelago.isRHMode():
		return
	var container = find_child("DomeContainersTeam1")
	desactivate_children_loadout_choices(container)

func desactivate_gadgets():
	if not GameWorld.archipelago.isRHMode():
		return
	var container = find_child("PrimaryGadgetContainersTeam1")
	desactivate_children_loadout_choices(container)

func desactivate_mapsizes():
	var container = find_child("MapsizeContainers")
	desactivate_children_loadout_choices(container)

func desactivate_difficulties():
	var container = find_child("DifficultyContainersRelicHunt")
	desactivate_children_loadout_choices(container)

func desactivate_modifiers():
	Level.loadout.modeConfig.erase(CONST.MODE_CONFIG_WORLDMODIFIERS)
	var container = find_child("Modifiers")
	desactivate_children_loadout_choices(container)

func desactivate_children_loadout_choices(container: Node):
	var children: Array[Node] = container.get_children()
	desactivate_loadout_choices(children)


func desactivate_loadout_choices(loadoutChoices: Array[Node]):
	for child in loadoutChoices:
		if child is PanelContainer:
			child.set_enabled(false)
			child.selected = false

func getMapSizeName(id: int) -> String:
	match id:
		0:
			return "regular-small"
		1:
			return "regular-medium"
		2:
			return "regular-large"
	return "regular-huge"
