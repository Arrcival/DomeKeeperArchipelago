extends Drop

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func set_number(number: int) -> void:
	if number <= 0 or number > 10:
		push_error("AP key number must be between 1 and 10; got %d" % number)
		return

	for key_sprite: Node in $Sprite2D.get_children():
		if key_sprite is Sprite2D:
			key_sprite.visible = key_sprite.name == "Key%d" % number

	type = CONSTARRC.AP_KEY + str(number)