extends "res://stages/loadout/AdditionalGadgetPopup.gd"


func _ready():
	super._ready()
	
	var container :Node = find_child("Gadgets")
	var childrens :Array[Node] = container.get_children()
	for i in range(len(childrens)):
		var children = childrens[i]
		if children is Label:
			var label :Label = children as Label
			if label.text == "Archipelago upgrades":
				print("yippie")
