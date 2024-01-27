extends "res://stages/manager/StageManager.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	var archipelagoClientNode = load("res://mods-unpacked/Arrcival-Archipelago/content/client/ArchipelagoClient.tscn").instance()
	add_child(archipelagoClientNode)
	var textChat = load("res://mods-unpacked/Arrcival-Archipelago/content/chat/TextChat.tscn").instance()
	add_child_first(find_node("Canvas"), textChat)
	
	
	GameWorld.archipelago.client.connect("item_received", self, "addItemToPool")

func addItemToPool(itemId: int):
	if itemId == 4242010 or itemId == 4242020:
		GameWorld.archipelago.keeperUpgradesCount += 1
	elif itemId == 4242030 or itemId == 4242040 or itemId == 4242060 or itemId == 4242080:
		GameWorld.archipelago.domeUpgradesCount += 1
	elif itemId == 4242100:
		GameWorld.archipelago.gadgetUpgradesCount += 1
	if itemId == 4242004:
		GameWorld.archipelago.cobaltRetrieved += 1
		
func add_child_first(node: Node, child: Node):
	node.add_child(child)
	node.move_child(child, 0)
