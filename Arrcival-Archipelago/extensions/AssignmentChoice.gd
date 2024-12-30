extends "res://stages/loadout/AssignmentChoice.gd"

var controlNode: Control
var archipelagoCheckOff: TextureRect
var archipelagoCheckOn: TextureRect
 
func _ready():
	controlNode = Control.new()
	archipelagoCheckOff = TextureRect.new()
	archipelagoCheckOn = TextureRect.new()
	archipelagoCheckOff.set_position(Vector2(-10, 56))
	archipelagoCheckOff.set_size(Vector2(40, 40))
	archipelagoCheckOn.set_position(Vector2(-10, 56))
	archipelagoCheckOn.set_size(Vector2(40, 40))
	archipelagoCheckOff.texture = load("res://mods-unpacked/Arrcival-Archipelago/content/icons/check/check_off.png")
	archipelagoCheckOn.texture = load("res://mods-unpacked/Arrcival-Archipelago/content/icons/check/check_on.png")
	archipelagoCheckOn.visible = false
	controlNode.add_child(archipelagoCheckOff)
	controlNode.add_child(archipelagoCheckOn)
	self.add_child(controlNode)
	
	$SelectedPanel.modulate.a = 0.0
	
	Style.init(self)

func makeVisibleAP():
	archipelagoCheckOff.visible = false
	archipelagoCheckOn.visible = true
