extends "res://content/caves/Cave.gd"

var hasItem: = true
var activated: = false
var grabs: = 0

# Archipelago
var locationId: int

# port from godot v3
func find_node(value: String) -> Node:
	return find_children(value)[0]
	
func _ready():
	super._ready()
	Style.init($Background / Slot1 / Resource)
	Style.init($Background / Slot2 / Resource)
	Style.init($Background / Slot3 / Resource)
	Style.init($Background / Slot4 / Resource)
	Style.init($Background / Slot5 / Resource)
	$Background / Slot1 / Resource.visible = false
	$Background / Slot2 / Resource.visible = false
	$Background / Slot3 / Resource.visible = false
	$Background / Slot4 / Resource.visible = false
	$Background / Slot5 / Resource.visible = false
	locationId = GameWorld.archipelago.getLocationCaveId()
	
func updateUsedTileCoords():
	tileCoords.clear()
	tileCoords.append(Vector2(0, 0))
	tileCoords.append(Vector2(1, 0))
	tileCoords.append(Vector2(0, 1))
	tileCoords.append(Vector2(1, 1))

func canFocusUse(keeper:Keeper)->bool:
	return hasItem and activated

func useHold(keeper:Keeper):
	return useHit(keeper)

func useHit(keeper:Keeper)->bool:
	if not hasItem:
		return false
	
	$ItemTakenSound.play()
	hasItem = false
	find_node("ActiveAmbSound").stop()
	$Background / Slot1.queue_free()
	$Background / Slot2.queue_free()
	$Background / Slot3.queue_free()
	$Background / Slot4.queue_free()
	$Background / Slot5.queue_free()
	$Background / Check / Checker.queue_free()
	
	GameWorld.archipelago.sendCheck(locationId)
	return true

func _on_Checker_animation_finished():
	if $Background / Check / Checker.animation == "activating":
		$Background / Check / Checker.play("active")
		activated = true

func _on_ResourceGrabber1_grabbed_resource():
	$Background / Slot1 / Resource.visible = true
	onResourceGrabbed()

func _on_ResourceGrabber2_grabbed_resource():
	$Background / Slot2 / Resource.visible = true
	onResourceGrabbed()

func _on_ResourceGrabber3_grabbed_resource():
	$Background / Slot3 / Resource.visible = true
	onResourceGrabbed()

func _on_ResourceGrabber4_grabbed_resource():
	$Background / Slot4 / Resource.visible = true
	onResourceGrabbed()

func _on_ResourceGrabber5_grabbed_resource():
	$Background / Slot5 / Resource.visible = true
	onResourceGrabbed()

func onResourceGrabbed():
	grabs += 1
	if grabs >= 5:
		find_node("ActiveAmbSound").play()
		$Background / Check / Checker.play("activating")

