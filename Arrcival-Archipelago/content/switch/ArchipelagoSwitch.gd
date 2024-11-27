extends "res://content/map/chamber/Chamber.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var id:int
var readyToUse: = false
var used: = false

func _ready():
	$Sprite.visible = false
	chamberType = CONSTARRC.TILE_ARCHIPELAGO_SWITCH


func deserialize(data:Dictionary):
	super.deserialize(data)
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

func onUsed():
	if readyToUse:
		$Sprite.play("empty")
		$Usable.queue_free()
		$ChamberSwitchHit.play()
		$ChamberAmbClosed.stop()
		$ChamberAmbClosed.queue_free()
		currentState = State.EMPTY
		var time: = 0.1
		$Tween.start()
		GameWorld.archipelago.submitSwitch(self.coord)
	else :
		used = true

func getTileType()->int:
	return CONSTARRC.TILE_ARCHIPELAGO_SWITCH
