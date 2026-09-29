extends "res://stages/manager/StageManager.gd"

# godot v3 port
func find_node(value: String) -> Node:
	var children: Array[Node] = find_children(value)
	if children != null and children.size() > 0:
		return children[0]
	return null

func _ready():
	var archipelagoClientNode = load("res://mods-unpacked/Arrcival-Archipelago/content/client/ArchipelagoClient.tscn").instantiate()
	add_child(archipelagoClientNode)
	GameWorld.archipelago.set_client(archipelagoClientNode)
	var textChat = load("res://mods-unpacked/Arrcival-Archipelago/content/chat/TextChat.tscn").instantiate()
	add_child_first(find_node("Canvas"), textChat)

func add_child_first(node: Node, child: Node):
	node.add_child(child)
	node.move_child(child, 0)

