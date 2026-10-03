extends "res://content/keeper/keeper3/Kunai.gd"

func _ready() -> void:
    super._ready()
    damage *= GameWorld.archipelago.get_mining_multiplier()