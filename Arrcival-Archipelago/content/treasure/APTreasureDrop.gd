extends Drop

var archipelagoId :int

func deactivate():
	super.deactivate()
	if archipelagoId != null:
		GameWorld.archipelago.sendCheck(archipelagoId)
		Audio.sound("progression_item")
	else:
		print("Drop has no archipelago id, which shouldn't happen!!")
