extends "res://content/map/chamber/Chamber.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var grabs: int = 0
var location_already_checked := false

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


	if not GameWorld.archipelago.is_relic_hunt():
		var id_assignment = Data.of("assignment.id")
		var assignment
		if id_assignment != null:
			assignment = Data.assignments.get(id_assignment)

		if assignment != null:
			chamber_archipelago_id = GameWorld.archipelago.get_location_chamber_id_ga(assignment.id)
	else:
		chamber_archipelago_id = GameWorld.archipelago.get_location_chamber_id_rh()

	location_already_checked = GameWorld.archipelago.has_checked_location(chamber_archipelago_id)
	if location_already_checked:
		show()
		currentState = State.EMPTY
		resetVisibility()
		$Sprite2D.play("empty")
		$Sprite2D.visible = true
		$SocketedGizmo.hide()
		disableResourceGrabbers()
		onUsed()
	print("Chamber archipelago id is : " + str(chamber_archipelago_id))

func resetVisibility():
	$Slots / Slot1 / Resource.visible = false
	$Slots / Slot2 / Resource.visible = false
	$Slots / Slot3 / Resource.visible = false
	$Slots / Slot4 / Resource.visible = false

func registerHit(playerId: String) -> void:
	if location_already_checked:
		return

	if multiplayer.is_server() and drop_type != "":
		var keeper = Keepers.getKeeper(playerId)
		var drop = Level.drops.network_spawn({
			"type": drop_type,
			"position": $GizmoSpawn.global_position,
			"carriers": [playerId],
			"team": keeper.teamId,
		})

		if is_instance_valid(drop):
			drop.archipelagoId = chamber_archipelago_id

	currentState = State.EMPTY
	onUsed()
	Backend.event("chamber", {"status": "used", "coord": tileCoords, "type": type})

func deserialize(data: Dictionary):
	super.deserialize(data)
	$Sprite2D.show()
	if location_already_checked:
		show()
		currentState = State.EMPTY
		$Sprite2D.play("empty")
		$SocketedGizmo.hide()
		return
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


func onRevealed():
	if location_already_checked:
		show()
		currentState = State.EMPTY
		$Sprite2D.play("empty")
		$Sprite2D.visible = true
		return
	$Sprite2D.play("default")
	$Sprite2D.visible = true

func _on_Sprite_animation_finished():
	if $Sprite2D.animation == "opening":
		currentState = State.OPEN
		$SocketedGizmo.visible = true

func _on_ResourceGrabber1_grabbed_resource():
	if location_already_checked:
		return
	$Slots / Slot1 / Resource.visible = true
	onResourceGrabbed()

func _on_ResourceGrabber2_grabbed_resource():
	if location_already_checked:
		return
	$Slots / Slot2 / Resource.visible = true
	onResourceGrabbed()

func _on_ResourceGrabber3_grabbed_resource():
	if location_already_checked:
		return
	$Slots / Slot3 / Resource.visible = true
	onResourceGrabbed()

func _on_ResourceGrabber4_grabbed_resource():
	if location_already_checked:
		return
	$Slots / Slot4 / Resource.visible = true
	onResourceGrabbed()

func onResourceGrabbed():
	if location_already_checked:
		return
	grabs += 1
	if grabs >= 4:
		resetVisibility()
		$Sprite2D.play("opening")
		$DoorOpen.play()

func disableResourceGrabbers() -> void:
	for grabber in [
		$Slots / Slot1 / ResourceGrabber1,
		$Slots / Slot2 / ResourceGrabber2,
		$Slots / Slot3 / ResourceGrabber3,
		$Slots / Slot4 / ResourceGrabber4,
	]:
		grabber.spent = true
		grabber.disable()

func onUsed():
	$Sprite2D.play("empty")
	$SocketedGizmo.queue_free()
	$Usable.queue_free()
	$GizmoSpawn/ChamberAmb.queue_free()
	$DoorOpen.queue_free()
	$GizmoSpawn.queue_free()

func getTileType() -> int:
	return CONSTARRC.TILE_CHAMBER
