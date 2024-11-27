extends "res://stages/manager/StageManager.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var json = JSON.new()

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
	if landingSequence:
		Level.levelSeed = GameWorld.archipelago.seedNumber
		return
	
	var loadoutStage: Node = get_node("CurrentStage/MultiplayerLoadoutStage")
	if not loadoutStage:
		return
	
	var moveableDevice = get_tree().get_nodes_in_group("moveable-device")[0]
	loadoutStage.keeperSelected(
		"keeper" + str(GameWorld.archipelago.keeperSlot + 1) + "-skin0",
		moveableDevice)
		
	
	loadoutStage.domeSelected(Data.loadoutDomes[GameWorld.archipelago.domeSlot])
	loadoutStage.primaryGadgetSelected(Data.loadoutGadgets[GameWorld.archipelago.domeGadgetSlot])
	loadoutStage.difficultySelected([-2, -1, 0, 2][GameWorld.archipelago.difficulty])
	loadoutStage.mapSizeSelected(getMapSizeName(GameWorld.archipelago.mapSize))
	desactivateKeeper(loadoutStage)
	desactivateDomes(loadoutStage)
	desactivateGadgets(loadoutStage)
	desactivateMapsizes(loadoutStage)
	desactivateDifficulties(loadoutStage)
	desactivateModifiers(loadoutStage)
	fillGameModes(loadoutStage)

func desactivateKeeper(loadoutStage: Node):
	var keeperContainers = loadoutStage.find_child("KeeperContainers")
	var i = 1 if GameWorld.archipelago.keeperSlot == 0 else 0
	var skinToRemoves = keeperContainers.get_children()[i]
	var gridCointainer = skinToRemoves.get_children()[2]
	findAndDesactivateChildrenLoadoutChoices(gridCointainer)

func desactivateDomes(loadoutStage: Node):
	var container = loadoutStage.find_child("DomeContainers")
	findAndDesactivateChildrenLoadoutChoices(container)

func desactivateGadgets(loadoutStage: Node):
	var container = loadoutStage.find_child("PrimaryGadgetContainers")
	findAndDesactivateChildrenLoadoutChoices(container)

func desactivateMapsizes(loadoutStage: Node):
	var container = loadoutStage.find_child("MapsizeContainers")
	findAndDesactivateChildrenLoadoutChoices(container)

func desactivateDifficulties(loadoutStage: Node):
	var container = loadoutStage.find_child("DifficultyContainers")
	findAndDesactivateChildrenLoadoutChoices(container)
		
func desactivateModifiers(loadoutStage: Node):
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

func fillGameModes(loadoutStage: Node):
	var node: VBoxContainer = loadoutStage.find_child("GameModeContainers")
	if node.get_child_count() > 2:
		node.get_child(2).visible = false
	if node.get_child_count() > 1:
		node.get_child(1).visible = false
		
func getMapSizeName(id: int) -> String:
	match id:
		0:
			return "regular-small"
		1:
			return "regular-medium"
		2:
			return "regular-large"
	return "regular-huge"
