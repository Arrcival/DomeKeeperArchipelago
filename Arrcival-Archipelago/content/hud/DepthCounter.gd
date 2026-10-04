extends HudElement

var depth_label : Label
var depth:=0

func init():
	super.init()
	depth_label = find_child("DepthLabel")
	Data.listen(self, teamId + ".archipelago.depth", true)

func propertyChanged(property: String, oldValue, newValue):
	if property == teamId + ".archipelago.depth":
		depth = newValue
		depth_label.text = str(depth)