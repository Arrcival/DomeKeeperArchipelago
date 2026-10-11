extends HudElement

var depth_label : Label
var depth:=0
var maxDepth:=0

func init():
	super.init()
	depth_label = find_child("DepthLabel")
	Data.listen(self, teamId + ".archipelago.depth", true)
	Data.listen(self, teamId + ".archipelago.maxDepth", true)

func _ready() -> void:
	GameWorld.archipelago.update_max_depth_hud()

func propertyChanged(property: String, oldValue, newValue):
	if property == teamId + ".archipelago.depth":
		depth = newValue
		updateText()
	if property == teamId + ".archipelago.maxdepth":
		maxDepth = newValue
		updateText()

func updateText():
	if maxDepth == 999:
		depth_label.text = str(depth)
		element_size.x = 7
		return

	depth_label.text = str(depth) + "/" + str(maxDepth)

	if element_size.x == 7 and maxDepth >= 100:
		element_size.x = 8
	if element_size.x == 8 and maxDepth < 100:
		element_size.x = 7
