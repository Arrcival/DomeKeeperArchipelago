extends "res://content/map/chamber/Chamber.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var id:int
var readyToUse: = false
var used: = false

var switch_ap_id: int
var location_already_checked := false

func _ready():
	super._ready()
	$Sprite.visible = false
	chamberType = CONSTARRC.TILE_ARCHIPELAGO_SWITCH
	switch_ap_id = GameWorld.archipelago.get_switch_id(self.coord)
	location_already_checked = GameWorld.archipelago.has_checked_location(switch_ap_id)
	if location_already_checked:
		show()
		currentState = State.EMPTY
		$Sprite.show()
		$Sprite.play("empty")
		reset()

func deserialize(data:Dictionary):
	super.deserialize(data)
	if location_already_checked:
		show()
		currentState = State.EMPTY
		$Sprite.show()
		$Sprite.play("empty")
		return
	if currentState == State.OPEN or currentState == State.OPENING:
		$Sprite.show()
		$Sprite.play("opening")
		$Sprite.frame = $Sprite.frames.get_frame_count("opening") - 1
	elif currentState == State.EMPTY:
		$Sprite.show()
		$Sprite.play("running")


func onExcavated():
	open()

func onOpening():
	$Tween.interpolate_callback(self, 0.4, "actuallyOpen")
	$Tween.start()

func actuallyOpen():
	$Sprite.play("opening")
	$DoorOpen.play()
	currentState = State.OPEN

func onRevealed():
	if location_already_checked:
		show()
		currentState = State.EMPTY
		$Sprite.show()
		$Sprite.play("empty")
		return
	if not currentState == State.EMPTY:
		$Sprite.play("default")
	$Sprite.visible = true
	$ChamberAmbClosed.play()

func _on_Sprite_animation_finished():
	if $Sprite.animation == "opening":
		readyToUse = true
		if used:
			onUsed()
	elif $Sprite.animation == "empty":
		$Sprite.play("running")

func onUsed() -> bool:
	if location_already_checked:
		return true
	if readyToUse:
		$ChamberSwitchHit.play()
		reset()
		GameWorld.archipelago.sendCheck(switch_ap_id)
		return true
	else :
		used = true
		return false

	
func reset():
	show()
	$Sprite.show()
	$Sprite.play("empty")
	$Usable.queue_free()
	$ChamberAmbClosed.stop()
	$ChamberAmbClosed.queue_free()
	currentState = State.EMPTY
	$Tween.start()

func getTileType()->int:
	return CONSTARRC.TILE_ARCHIPELAGO_SWITCH
