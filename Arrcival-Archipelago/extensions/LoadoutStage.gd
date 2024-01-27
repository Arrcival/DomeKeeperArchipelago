extends "res://stages/loadout/LoadoutStage.gd"


func _ready():
	disableEveryButtons()

func beforeStart():
	.beforeStart()
	disableEveryButtons()
	updateBasedOnClient()

func disableEveryButtons():
	disableButton(DomeButton)
	disableButton(find_node("KeeperButton"))
	disableButton(find_node("GadgetButton"))

func disableButton(node):
	node.disabled = true

func updateBasedOnClient():
	setKeeper("keeper" + str(GameWorld.archipelago.client._keeper + 1))
	setDome("dome" + str(GameWorld.archipelago.client._dome + 1))
	match GameWorld.archipelago.client._domeGadget:
		0:
			setGadget("shield")
		1:
			setGadget("orchard")
		2:
			setGadget("repellent")
