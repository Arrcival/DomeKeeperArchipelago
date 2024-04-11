extends "res://stages/loadout/LoadoutStage.gd"

# Make most buttons not clickable but set based on AP slot data

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
	setKeeper("keeper" + str(GameWorld.archipelago.keeperSlot + 1))
	setDome("dome" + str(GameWorld.archipelago.domeSlot + 1))
	match GameWorld.archipelago.domeGadgetSlot:
		0:
			setGadget("shield")
		1:
			setGadget("orchard")
		2:
			setGadget("repellent")
