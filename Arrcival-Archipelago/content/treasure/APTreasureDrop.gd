extends Drop

var archipelagoId :int

func deactivate():
	super.deactivate()
	Audio.sound("progression_item")
	GameWorld.archipelago.sendCheck(archipelagoId)
