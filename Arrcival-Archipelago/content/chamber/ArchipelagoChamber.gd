extends  "res://content/map/chamber/Chamber.gd"


const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var grabs: int = 0

var chamber_archipelago_id : int

func _ready():
	super._ready()
	$Sprite2D.visible = false
	$SocketedGizmo.visible = false
	
	Style.init($Slots / Slot1 / Resource)
	Style.init($Slots / Slot2 / Resource)
	Style.init($Slots / Slot3 / Resource)
	Style.init($Slots / Slot4 / Resource)
	resetVisibility()
	chamberType = CONSTARRC.TILE_CHAMBER
	var assignment = Data.assignments.get(Data.of("assignment.id"))
	if assignment != null:
		chamber_archipelago_id = GameWorld.archipelago.getLocationChamberId(assignment.id)
	else:
		chamber_archipelago_id = GameWorld.archipelago.getLocationChamberId()

func resetVisibility():
	$Slots / Slot1 / Resource.visible = false
	$Slots / Slot2 / Resource.visible = false
	$Slots / Slot3 / Resource.visible = false
	$Slots / Slot4 / Resource.visible = false


func deserialize(data: Dictionary):
	super.deserialize(data)
	$Sprite2D.show()
	if currentState == State.OPEN or currentState == State.OPENING:
		$Sprite2D.play("opening")
		$Sprite2D.frame = $Sprite2D.sprite_frames.get_frame_count("opening")-1
		$SocketedGizmo.show()
	elif currentState == State.EMPTY:
		$Sprite2D.play("empty")
		$SocketedGizmo.hide()

func updateUsedTileCoords():
	tileCoords.clear()
	tileCoords.append(Vector2(0, 0))
	tileCoords.append(Vector2(1, 0))
	tileCoords.append(Vector2(0, 1))
	tileCoords.append(Vector2(1, 1))

func useHit(keeper:Keeper) -> bool:
	if currentState == State.OPEN:
		if GIZMO_SCENE:
			var gizmo = GIZMO_SCENE.instantiate()
			gizmo.archipelagoId = chamber_archipelago_id
			gizmo.position = find_child("GizmoSpawn").global_position
			Level.map.addDrop(gizmo)
			keeper.attachCarry(gizmo)
		currentState = State.EMPTY
		onUsed()
		Backend.event("chamber", {"status": "used", "coord":tileCoords, "type": type})
		return true
	else:
		return false


func onRevealed():
	$Sprite2D.play("default")
	$Sprite2D.visible = true

func _on_Sprite_animation_finished():
	if $Sprite2D.animation == "opening":
		currentState = State.OPEN
		$SocketedGizmo.visible = true

func _on_ResourceGrabber1_grabbed_resource():
	$Slots / Slot1 / Resource.visible = true
	onResourceGrabbed()

func _on_ResourceGrabber2_grabbed_resource():
	$Slots / Slot2 / Resource.visible = true
	onResourceGrabbed()

func _on_ResourceGrabber3_grabbed_resource():
	$Slots / Slot3 / Resource.visible = true
	onResourceGrabbed()

func _on_ResourceGrabber4_grabbed_resource():
	$Slots / Slot4 / Resource.visible = true
	onResourceGrabbed()

func onResourceGrabbed():
	grabs += 1
	if grabs >= 4:
		resetVisibility()
		$Sprite2D.play("opening")
		$DoorOpen.play()

func onUsed():
	$Sprite2D.play("empty")
	$SocketedGizmo.queue_free()
	$Usable.queue_free()
	$GizmoSpawn/ChamberAmb.queue_free()
	$DoorOpen.queue_free()
	$GizmoSpawn.queue_free()

func getTileType() -> int:
	return CONSTARRC.TILE_CHAMBER
