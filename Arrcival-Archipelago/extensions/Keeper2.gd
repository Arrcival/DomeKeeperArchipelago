extends "res://content/keeper/keeper2/Keeper2.gd"

func is_potential_carryable(carryable : Carryable) -> bool:
	if carryable.carryableType == "charm":
		return true

	return super.is_potential_carryable(carryable)

func currentSpeed() -> float:
	var speed = super.currentSpeed()
	if not GameWorld.archipelago.is_relic_hunt():
		speed *= GameWorld.archipelago.get_speed_multiplier()

	return speed