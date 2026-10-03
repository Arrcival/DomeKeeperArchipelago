extends "res://content/keeper/keeper2/Pinball.gd" 

func _ready():
	super._ready()
	baseDamage *= GameWorld.archipelago.get_mining_multiplier()