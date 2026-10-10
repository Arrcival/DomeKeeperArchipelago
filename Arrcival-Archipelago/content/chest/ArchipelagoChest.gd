extends "res://content/map/chamber/Chamber.gd"


const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var grabs: int = 0

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
	set_key_and_archipelago()


func set_key_and_archipelago():
	chest_archipelago_id = CONSTARRC.CHEST_LOCATION_ID + chest_number
	print("Chest archipelago id is : " + str(chest_archipelago_id))
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
	$Sprite2D.play("default")
	$Sprite2D.visible = true

func _on_Sprite_animation_finished():
	if $Sprite2D.animation == "opening":
		currentState = State.OPEN
		$SocketedGizmo.visible = true

func _on_ResourceGrabber_grabbed_resource():
	$Slot / Resource.visible = true
	onResourceGrabbed()

func onResourceGrabbed():
	grabs += 1
	if grabs >= 1:
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
	return CONSTARRC.TILE_CHEST
