extends "res://gui/PopupInput.gd"

func buttonEvent(event) -> bool:
	return false

func handle(event) -> bool:
	if event is InputEventKey:
		return buttonEvent(event)
	return false
