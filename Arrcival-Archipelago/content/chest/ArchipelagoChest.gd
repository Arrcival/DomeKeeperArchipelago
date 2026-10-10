extends "res://content/map/chamber/Chamber.gd"


const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var grabs: int = 0
var location_already_checked := false

var chest_archipelago_id : int
var chest_number: int

func _ready():
	super._ready()
	$Sprite2D.visible = false
	$SocketedGizmo.visible = false
	
	Style.init($Slot / Resource)
	resetVisibility()
	chamberType = CONSTARRC.TILE_CHAMBER

	if not GameWorld.archipelago.is_relic_hunt():
		print("Tried to generate a chest in ga, which shouldn't happen!")


	chest_number = GameWorld.archipelago.get_location_chest_id()
	chest_archipelago_id = CONSTARRC.CHEST_LOCATION_ID + chest_number
	print("Chest archipelago id is : " + str(chest_archipelago_id))

	location_already_checked = GameWorld.archipelago.has_checked_location(chest_archipelago_id)
	if location_already_checked:
		show()
		currentState = State.EMPTY
		resetVisibility()
		$Sprite2D.play("empty")
		$Sprite2D.show()
		$SocketedGizmo.hide()
		disableResourceGrabber()
		onUsed()
	else:
		set_key_and_archipelago()


func set_key_and_archipelago():
	var resource_grabber: ResourceGrabber = find_child("ResourceGrabber")
	resource_grabber.dropType = CONSTARRC.AP_KEY + str(chest_number + 1)

	for key_sprite: Node in $KeyNumber.get_children():
		if key_sprite is Sprite2D:
			key_sprite.visible = key_sprite.name == "Key%d" % (chest_number + 1)

func resetVisibility():
	$Slot / Resource.visible = false
	for key_sprite: Node in $KeyNumber.get_children():
		if key_sprite is Sprite2D:
			key_sprite.visible = false

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
			drop.archipelagoId = chest_archipelago_id

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
		$Sprite2D.show()
		return
	$Sprite2D.play("default")
	$Sprite2D.visible = true

func _on_Sprite_animation_finished():
	if $Sprite2D.animation == "opening":
		currentState = State.OPEN
		$SocketedGizmo.visible = true

func _on_ResourceGrabber_grabbed_resource():
	if location_already_checked:
		return
	$Slot / Resource.visible = true
	onResourceGrabbed()

func onResourceGrabbed():
	if location_already_checked:
		return
	grabs += 1
	if grabs >= 1:
		resetVisibility()
		$Sprite2D.play("opening")
		$DoorOpen.play()

func disableResourceGrabber() -> void:
	var grabber: ResourceGrabber = find_child("ResourceGrabber")
	if grabber != null:
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
	return CONSTARRC.TILE_CHEST
