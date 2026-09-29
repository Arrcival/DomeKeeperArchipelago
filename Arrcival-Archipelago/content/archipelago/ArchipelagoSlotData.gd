class_name ArchipelagoSlotData

const CONSTARRC: GDScript = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

const DEFAULT_ASSIGNMENTS_AMOUNT: int = 25

enum PROGRESSION_TYPE {
	RELIC_HUNT = 0,
	RELIC_HUNT_COLORED_LAYERS = 1,
	GUILD_ASSIGNMENT = 2,
}

var seedNumber: int = 0
var keeperSlot: int = 0
var domeSlot: int = 0
var domeGadgetSlot: int = 0
var mapSize: int = 0
var difficulty: int = 0
var drillUpgrades: int = 0
var kineticSphereUpgrades: int = 0
var sphereLifetime: int = 0
var kunaiUpgrades: int = 0
var beastmasterMiningUpgrades: int = 0
var catgoblinsAmount: int = 0
var dronesAmount: int = 0
var progressionType: int = PROGRESSION_TYPE.RELIC_HUNT
var switchesPerLayer: Array = []
var miningEverything: bool = false
var startingGuildAssignment: int = 0
var challengeMode: bool = false
var assignmentsAmount: int = DEFAULT_ASSIGNMENTS_AMOUNT
var death_link: bool = false

func reset() -> void:
	seedNumber = 0
	keeperSlot = 0
	domeSlot = 0
	domeGadgetSlot = 0
	mapSize = 0
	difficulty = 0
	drillUpgrades = 0
	kineticSphereUpgrades = 0
	sphereLifetime = 0
	kunaiUpgrades = 0
	beastmasterMiningUpgrades = 0
	catgoblinsAmount = 0
	dronesAmount = 0
	progressionType = PROGRESSION_TYPE.RELIC_HUNT
	switchesPerLayer.clear()
	miningEverything = false
	startingGuildAssignment = 0
	challengeMode = false
	assignmentsAmount = DEFAULT_ASSIGNMENTS_AMOUNT
	death_link = false

func apply(raw_slot_data: Dictionary) -> void:
	reset()

	if raw_slot_data.has("seed"):
		seedNumber = int(raw_slot_data["seed"])
	if raw_slot_data.has("keeper"):
		keeperSlot = int(raw_slot_data["keeper"])
	if raw_slot_data.has("dome"):
		domeSlot = int(raw_slot_data["dome"])
	if raw_slot_data.has("domeGadget"):
		domeGadgetSlot = int(raw_slot_data["domeGadget"])
	if raw_slot_data.has("mapSize"):
		mapSize = int(raw_slot_data["mapSize"])
	if raw_slot_data.has("difficulty"):
		difficulty = int(raw_slot_data["difficulty"])
	if raw_slot_data.has("switchesPerLayer"):
		switchesPerLayer = raw_slot_data["switchesPerLayer"].duplicate()
	if raw_slot_data.has("drillUpgrades"):
		drillUpgrades = int(raw_slot_data["drillUpgrades"])
	if raw_slot_data.has("kineticSpheres"):
		kineticSphereUpgrades = int(raw_slot_data["kineticSpheres"])
	if raw_slot_data.has("kunaiUpgrades"):
		kunaiUpgrades = int(raw_slot_data["kunaiUpgrades"])
	if raw_slot_data.has("catgoblinsAmount"):
		catgoblinsAmount = int(raw_slot_data["catgoblinsAmount"])
	if raw_slot_data.has("beastmasterMiningUpgrades"):
		beastmasterMiningUpgrades = int(raw_slot_data["beastmasterMiningUpgrades"])
	if raw_slot_data.has("sphereLifetime"):
		sphereLifetime = int(raw_slot_data["sphereLifetime"])
	if raw_slot_data.has("dronesAmount"):
		dronesAmount = int(raw_slot_data["dronesAmount"])
	if raw_slot_data.has("progressionType"):
		var received_progression_type := int(raw_slot_data["progressionType"])
		if received_progression_type >= PROGRESSION_TYPE.RELIC_HUNT and received_progression_type <= PROGRESSION_TYPE.GUILD_ASSIGNMENT:
			progressionType = received_progression_type
		else:
			push_warning("Invalid progression type received: %s. Falling back to Relic Hunt." % received_progression_type)
			progressionType = PROGRESSION_TYPE.RELIC_HUNT
	if raw_slot_data.has("miningEverything"):
		miningEverything = bool(raw_slot_data["miningEverything"])
	if raw_slot_data.has("startingGA"):
		startingGuildAssignment = int(raw_slot_data["startingGA"])
	if raw_slot_data.has("challengeMode"):
		challengeMode = bool(raw_slot_data["challengeMode"])
	if raw_slot_data.has("assignmentsAmount"):
		assignmentsAmount = int(raw_slot_data["assignmentsAmount"])
	if raw_slot_data.has("deathLink"):
		death_link = bool(raw_slot_data["deathLink"])

func is_relic_hunt() -> bool:
	return progressionType == PROGRESSION_TYPE.RELIC_HUNT

func is_relic_hunt_with_colored_layers() -> bool:
	return progressionType == PROGRESSION_TYPE.RELIC_HUNT_COLORED_LAYERS

func is_guild_assignment() -> bool:
	return progressionType == PROGRESSION_TYPE.GUILD_ASSIGNMENT

func get_assignment_id(assignment: String) -> int:
	var index := CONSTARRC.ASSIGNMENTS_LIST.find(assignment)
	return maxi(index, 0)

func get_seed(assignment: String = "showdown") -> int:
	if is_relic_hunt() or is_relic_hunt_with_colored_layers():
		return seedNumber
	return seedNumber + get_assignment_id(assignment)

func get_layer_unlock_count() -> int:
	if mapSize == 1:
		return 3
	if mapSize == 2:
		return 5
	if mapSize == 3:
		return 6
	return 2
