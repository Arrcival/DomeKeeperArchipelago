extends Drop

var archipelagoId :int

func _ready():
	super._ready()
	dropTargetRef = Level.dome.ArtifactDropPoint

func deactivate():
	super.deactivate()
	Audio.sound("progression_item")
	GameWorld.archipelago.sendCheck(archipelagoId)
