extends "res://stages/manager/StageManager.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	var archipelagoClientNode = load("res://mods-unpacked/Arrcival-Archipelago/content/client/ArchipelagoClient.tscn").instance()
	add_child(archipelagoClientNode)
	var textChat = load("res://mods-unpacked/Arrcival-Archipelago/content/chat/TextChat.tscn").instance()
	add_child_first(find_node("Canvas"), textChat)
	
	
	GameWorld.archipelago.client.connect("item_received", self, "addItemToPool")

func addItemToPool(itemId: int):
	GameWorld.archipelago.itemsIdFound.append(itemId)
		
func add_child_first(node: Node, child: Node):
	node.add_child(child)
	node.move_child(child, 0)
