extends "res://stages/loadout/MultiplayerloadoutStage.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var json = JSON.new()

var keeper: Keeper

func build(data: Array):
	super.build(data)
	
	if GameWorld.archipelago.is_relic_hunt():
		var slot_data = GameWorld.archipelago.get_relic_hunt_slot_data()
		domeSelected(Data.loadoutDomes[slot_data["domeSlot"]], "team1", false)
		primaryGadgetSelected(Data.loadoutGadgets[slot_data["domeGadgetSlot"]], "team1", false)
		difficultySelected([-2, -1, 0, 2][slot_data["difficulty"]], "team1", false)
		mapSizeSelected(getMapSizeName(slot_data["mapSize"]))
		desactivate_keepers(slot_data["keeper"])
		desactivate_domes()
		desactivate_gadgets()
		desactivate_mapsizes()
		desactivate_difficulties()
		desactivate_modifiers()
	else:
		manageAssignments()

#extending
func spawn_keeper(loadout_keeper: LoadoutKeeper) -> void:
	var slot_data = GameWorld.archipelago.get_relic_hunt_slot_data()
	if multiplayer.is_server() and loadout_keeper.playerId == "player1":
		loadout_keeper.keeperId = "keeper" + str(slot_data["keeper"] + 1)
		loadout_keeper.skinId = "skin0"

	super.spawn_keeper(loadout_keeper)

func fillGameModes():
	super.fillGameModes()

	var mode_id: String = (
		CONST.MODE_RELICHUNT
		if GameWorld.archipelago.is_relic_hunt()
		else CONST.MODE_ASSIGNMENTS
	)

	var container: Node = find_child("GameModeContainers")
	for choice in container.get_children():
		if choice is LoadoutChoice:
			choice.set_enabled(false)

	gameModeSelected(mode_id, false)

func manageAssignments():
	if GameWorld.archipelago.is_relic_hunt():
		return
	assignmentSelected(GameWorld.archipelago.get_starting_assignment_name())
	var assignments = find_child("AssignmentsContainer")
	for assignment in assignments.get_children():
		assignment.set_enabled(GameWorld.archipelago.isGAUnlocked(assignment.id))
		if GameWorld.archipelago.isGADone(assignment.id):
			assignment.makeVisibleAP()

func desactivate_keepers(keeper_selected: int):
	if not GameWorld.archipelago.is_relic_hunt():
		return
	var kc = find_child("KeeperContainers")
	for i in range(4):
		if i == keeper_selected:
			continue

		var keeperBox :Node = kc.get_child(i) # Container of keeper

		var keeperSkins: GridContainer = keeperBox.get_child(2) # Grid container of KeeperSelect scene
		for keeperChild in keeperSkins.get_children():
			keeperChild.set_enabled(false)


func desactivate_domes():
	if not GameWorld.archipelago.is_relic_hunt():
		return
	var container = find_child("DomeContainersTeam1")
	desactivate_children_loadout_choices(container)

func desactivate_gadgets():
	if not GameWorld.archipelago.is_relic_hunt():
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
