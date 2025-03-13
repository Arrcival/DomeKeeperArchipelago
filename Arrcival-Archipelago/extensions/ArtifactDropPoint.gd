extends "res://content/dome/ArtifactDropPoint.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func _on_ArtifactDropPoint_area_entered(area):
	var drop = area.getDeliverableDrop(CONSTARRC.CHARM)
	if drop:
		drop.floatToDropTarget(self)
	else:
		super._on_ArtifactDropPoint_area_entered(area)
