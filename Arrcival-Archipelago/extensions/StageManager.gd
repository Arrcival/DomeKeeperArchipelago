extends "res://stages/manager/StageManager.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var json = JSON.new()

var loadoutStage: Node

# godot v3 port
func find_node(value: String) -> Node:
	var children: Array[Node] = find_children(value)
	if children != null and children.size() > 0:
		return children[0]
	return null

func _ready():
	var archipelagoClientNode = load("res://mods-unpacked/Arrcival-Archipelago/content/client/ArchipelagoClient.tscn").instantiate()
	add_child(archipelagoClientNode)
	GameWorld.archipelago.client = archipelagoClientNode
	var textChat = load("res://mods-unpacked/Arrcival-Archipelago/content/chat/TextChat.tscn").instantiate()
	add_child_first(find_node("Canvas"), textChat)
	
	GameWorld.archipelago.client.item_received.connect(self.addItemToPool)
	
	var options: Dictionary = loadDictionary(CONSTARRC.SAVE_OPTIONS_ARCHIPELAGO)
	setArchipelagoOptions(options)

func loadDictionary(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	
	var file = FileAccess.open(path, FileAccess.READ)
	var theDict = json.parse_string(file.get_as_text())
	file.close()
	return theDict

func setArchipelagoOptions(options: Dictionary):
	if options.has("slotName"):
		GameWorld.archipelago.slotName = options["slotName"]
	if options.has("serverName"):
		GameWorld.archipelago.serverName = options["serverName"]
	if options.has("password"):
		GameWorld.archipelago.password = options["password"]

func addItemToPool(itemId: int):
	GameWorld.archipelago.itemsIdFound.append(itemId)
		
func add_child_first(node: Node, child: Node):
	node.add_child(child)
	node.move_child(child, 0)

func startStage(stageName:String, data:Array=[], tabula:bool = true):
	if stageName == "stages/landing/landing":
		Level.levelSeed = GameWorld.archipelago.seedNumber
	
	super.startStage(stageName, data, tabula)

func _startNewStage():
	super._startNewStage()
	
	
	var landingSequence: Node = get_node("CurrentStage/LandingSequence")
	if landingSequence and GameWorld.archipelago.isRHMode():
		Level.levelSeed = GameWorld.archipelago.seedNumber
		return
	
	loadoutStage = get_node("CurrentStage/MultiplayerLoadoutStage")
	if not loadoutStage:
		return
	
	var moveableDevice = get_tree().get_nodes_in_group("moveable-device")[0]
	loadoutStage.keeperSelected(
		"keeper" + str(GameWorld.archipelago.keeperSlot + 1) + "-skin0",
		moveableDevice)
	
	if not GameWorld.archipelago.isRHMode():
		GameWorld.archipelago.processUnlocks()
	GameWorld.archipelago.ga_unlocked.connect(activate_assignment)
	
	fillGameModes()
	loadoutStage.domeSelected(Data.loadoutDomes[GameWorld.archipelago.domeSlot])
	loadoutStage.primaryGadgetSelected(Data.loadoutGadgets[GameWorld.archipelago.domeGadgetSlot])
	loadoutStage.difficultySelected([-2, -1, 0, 2][GameWorld.archipelago.difficulty])
	loadoutStage.mapSizeSelected(getMapSizeName(GameWorld.archipelago.mapSize))
	manageAssignments()
	desactivateKeeper()
	desactivateDomes()
	desactivateGadgets()
	desactivateMapsizes()
	desactivateDifficulties()
	desactivateModifiers()

func activate_assignment(assignment_id: int) -> void:
	if loadoutStage != null:
		var assignments = loadoutStage.find_child("AssignmentsContainer")
		var assignment: Node = assignments.get_children()[assignment_id]
		assignment.set_enabled(true)

func manageAssignments():
	if GameWorld.archipelago.isRHMode():
		return
	loadoutStage.assignmentSelected(GameWorld.archipelago.get_starting_assignment_name())
	var assignments = loadoutStage.find_child("AssignmentsContainer")
	for assignment in assignments.get_children():
		assignment.set_enabled(GameWorld.archipelago.isGAUnlocked(assignment.id))
		if GameWorld.archipelago.isGADone(assignment.id):
			assignment.makeVisibleAP()

func desactivateKeeper():
	if not GameWorld.archipelago.isRHMode():
		return
	var keeperContainers = loadoutStage.find_child("KeeperContainers")
	var i = 1 if GameWorld.archipelago.keeperSlot == 0 else 0
	var skinToRemoves = keeperContainers.get_children()[i]
	var gridCointainer = skinToRemoves.get_children()[2]
	findAndDesactivateChildrenLoadoutChoices(gridCointainer)

func desactivateDomes():
	if not GameWorld.archipelago.isRHMode():
		return
	var container = loadoutStage.find_child("DomeContainers")
	findAndDesactivateChildrenLoadoutChoices(container)

func desactivateGadgets():
	if not GameWorld.archipelago.isRHMode():
		return
	var container = loadoutStage.find_child("PrimaryGadgetContainers")
	findAndDesactivateChildrenLoadoutChoices(container)

func desactivateMapsizes():
	var container = loadoutStage.find_child("MapsizeContainers")
	findAndDesactivateChildrenLoadoutChoices(container)

func desactivateDifficulties():
	var container = loadoutStage.find_child("DifficultyContainers")
	findAndDesactivateChildrenLoadoutChoices(container)

func desactivateModifiers():
	var container = loadoutStage.find_child("Modifiers")
	findAndDesactivateChildrenLoadoutChoices(container)

func findAndDesactivateChildrenLoadoutChoices(container: Node):
	var children: Array[Node] = container.get_children()
	desactivateLoadoutChoices(children)

func desactivateLoadoutChoices(loadoutChoices: Array[Node]):
	for child in loadoutChoices:
		if child is PanelContainer:
			child.set_enabled(false)
			child.selected = false

func fillGameModes():
	var node: VBoxContainer = loadoutStage.find_child("GameModeContainers")
	node.get_child(0).set_enabled(GameWorld.archipelago.isRHMode())
	node.get_child(1).set_enabled(!GameWorld.archipelago.isRHMode())
	node.get_child(2).set_enabled(false)
	
	if GameWorld.archipelago.isRHMode():
		node.get_child(0).useHit(null)
	else:
		node.get_child(1).useHit(null)

func getMapSizeName(id: int) -> String:
	match id:
		0:
			return "regular-small"
		1:
			return "regular-medium"
		2:
			return "regular-large"
	return "regular-huge"
