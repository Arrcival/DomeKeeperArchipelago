extends "res://stages/manager/StageManager.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func _ready():
	var archipelagoClientNode = load("res://mods-unpacked/Arrcival-Archipelago/content/client/ArchipelagoClient.tscn").instance()
	add_child(archipelagoClientNode)
	var textChat = load("res://mods-unpacked/Arrcival-Archipelago/content/chat/TextChat.tscn").instance()
	add_child_first(find_node("Canvas"), textChat)
	
	GameWorld.archipelago.client.connect("item_received", self, "addItemToPool")
	
	var options: Dictionary = loadDictionary(CONSTARRC.SAVE_OPTIONS_ARCHIPELAGO)
	setArchipelagoOptions(options)

func loadDictionary(path: String) -> Dictionary:
	var file: File = File.new()
	
	if not file.file_exists(path):
		return {}
	
	file.open(path, File.READ)
	var theDict = file.get_var()
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
