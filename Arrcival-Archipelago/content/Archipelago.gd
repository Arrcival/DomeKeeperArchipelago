# To compute back on new game
var cobaltRetrieved: int = 0
var cobaltGiven: int = 0
var itemsIdFound: Array = []
var itemsFoundToProcess: Array = []

var switchesFoundIndexes: Array = [] 

var switches: Array = []

# websocket client
var client

var locationIds: Dictionary = {
	"archipelagoupgradeiron1": 4243001,
	"archipelagoupgradeiron2": 4243002,
	"archipelagoupgradeiron3": 4243003,
	"archipelagoupgradeiron4": 4243004,
	"archipelagoupgradewater1": 4243005,
	"archipelagoupgradewater2": 4243006,
	"archipelagoupgradewater3": 4243007,
	"archipelagoupgradewater4": 4243008,
	"archipelagoupgradeironwater1": 4243009,
	"archipelagoupgradeironwater2": 4243010,
	"archipelagoupgradeironwater3": 4243011,
	"archipelagoupgradeironwater4": 4243012
}

const FIRST_SWITCH_ID := 4243101

var upgrades_keeper1_drill: Array = []
var upgrades_keeper1_jetpack: Array = []
var upgrades_keeper1_carry: Array = []

var upgrades_keeper2_movement: Array = []
var upgrades_keeper2_damage: Array = []
var upgrades_keeper2_bundle: Array = []
var upgrades_keeper2_more_spheres: Array = []
var upgrades_keeper2_lifetime: Array = []
var upgrades_keeper2_special: Array = []
var upgrades_keeper2_mining: Array = []

var upgrades_laser_strength: Array = []
var upgrades_laser_speed: Array = []
var upgrades_laser_aimline: Array = []

var upgrades_sword_strength: Array = []
var upgrades_sword_stab: Array = []
var upgrades_sword_aimline: Array = []
var upgrades_sword_reflection: Array = []

var upgrades_artillery_mortar: Array = []
var upgrades_artillery_machinegun: Array = []

var upgrades_tesla_reticlespeed: Array = []
var upgrades_tesla_quickshot: Array = []
var upgrades_tesla_shotpower: Array = []
var upgrades_tesla_autoaim: Array = []
var upgrades_tesla_orb: Array = []

var upgrades_orchard_duration: Array = []
var upgrades_orchard_overcharge: Array = []
var upgrades_orchard_special: Array = []
var upgrades_orchard_speedboost: Array = []
var upgrades_orchard_miningboost: Array = []

var upgrades_shield_strength: Array = []
var upgrades_shield_special: Array = []
var upgrades_shield_overcharge: Array = []

var upgrades_repellent_delay: Array = []
var upgrades_repellent_special: Array = []
var upgrades_repellent_overcharge: Array = []

# Names like sent to client
var keeper: String = ""
var dome: String = ""
var primaryGadget: String = ""

var slotName: String = ""
var serverName: String = "archipelago.gg"
var password: String = ""

signal signal_item

# slot data
var seedNumber: int = 0
var keeperSlot: int
var domeSlot: int
var domeGadgetSlot: int
var mapSize: int
var difficulty: int
var drillUpgrades: int
var kineticSphereUpgrades: int
var sphereLifetime: int
var coloredLayersProgression: bool
var switchesPerLayers: Array = []
var miningEverything: bool
var death_link = false

var coloredLayersUnlocked: int = 0
var everyLayersUnlockFound: bool = false
var tilesLeft: int = 0

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

signal logInformations(text)

func connectClient():
	client.connectToServer(serverName, slotName, password)
	client.connect("slot_data_retrieved", self, "retrieveSlotData")

func retrieveSlotData(slot_data):
	if slot_data.has("seed"):
		seedNumber = int(slot_data["seed"])
	if slot_data.has("keeper"):
		keeperSlot = slot_data["keeper"]
	if slot_data.has("dome"):
		domeSlot = slot_data["dome"]
	if slot_data.has("domeGadget"):
		domeGadgetSlot = slot_data["domeGadget"]
	if slot_data.has("mapSize"):
		mapSize = slot_data["mapSize"]
	if slot_data.has("difficulty"):
		difficulty = slot_data["difficulty"]
	if slot_data.has("switchesPerLayers"):
		switchesPerLayers = slot_data["switchesPerLayers"]
	if slot_data.has("drillUpgrades"):
		drillUpgrades = slot_data["drillUpgrades"]
	if slot_data.has("kineticSpheres"):
		kineticSphereUpgrades = slot_data["kineticSpheres"]
	if slot_data.has("sphereLifetime"):
		sphereLifetime = slot_data["sphereLifetime"]
	if slot_data.has("coloredLayersProgression"):
		coloredLayersProgression = bool(slot_data["coloredLayersProgression"])
	if slot_data.has("miningEverything"):
		miningEverything = bool(slot_data["miningEverything"])

func submitSwitch(switchPos: Vector2):
	
	var totalTiles = Data.of("map.totaltiles")
	print("Tiles destroyed : " + str(Data.of("map.tiledestroyed")))
	print("Tiles total : " + str(Data.of("map.totaltiles") - 1))
	print("Tiles remaining : ")
	print(Data.of("map.totaltiles") - Data.of("map.tiledestroyed") + 1)

	var index = switches.find(switchPos, 0)
	if index != -1:
		var switchId = FIRST_SWITCH_ID + index
		switchesFoundIndexes.append(switchId)
		client.sendLocation(switchId)

func submitUpgrade(upgradeName):
	var locationId = locationIds.get(upgradeName)
	if locationId != null:
		 client.sendLocation(locationId)

func generateUpgrades():
	cobaltRetrieved = 0
	cobaltGiven = 0
	coloredLayersUnlocked = 0
	itemsFoundToProcess = itemsIdFound.duplicate()
	
	upgrades_keeper1_drill = getKeeper1Drills()
	upgrades_keeper1_jetpack = CONSTARRC.KEEPER1_JETPACK.duplicate()
	upgrades_keeper1_carry = CONSTARRC.KEEPER1_CARRY.duplicate()
	
	upgrades_keeper2_movement = CONSTARRC.KEEPER2_MOVEMENT.duplicate()
	upgrades_keeper2_damage = getKeeper2Spheres()
	upgrades_keeper2_bundle = CONSTARRC.KEEPER2_BUNDLE.duplicate()
	upgrades_keeper2_more_spheres = CONSTARRC.KEEPER2_MORESPHERES.duplicate()
	upgrades_keeper2_lifetime = getSphereLifetime()
	upgrades_keeper2_mining = CONSTARRC.KEEPER2_MINING.duplicate()
	upgrades_keeper2_special = pickRandom(CONSTARRC.KEEPER2_SPECIAL_CHOICES)
	
	upgrades_laser_strength = CONSTARRC.LASER_STRENGTH.duplicate() + pickAllRandom(CONSTARRC.LASER_STRENGTH_ROLL) + CONSTARRC.LASER_STRENGTH_AFTER_ROLL.duplicate()
	upgrades_laser_speed = CONSTARRC.LASER_SPEED.duplicate() + pickAllRandom(CONSTARRC.LASER_SPEED_ROLL) + CONSTARRC.LASER_SPEED_AFTER_ROLL.duplicate()
	upgrades_laser_aimline = CONSTARRC.LASER_AIMLINE.duplicate()
	upgrades_sword_strength = CONSTARRC.SWORD_STRENGTH.duplicate() + pickRandom(CONSTARRC.SWORD_STRENGTH_CHOICES)
	upgrades_sword_stab = pickRandom(CONSTARRC.SWORD_STAB_CHOICES)
	upgrades_sword_aimline = CONSTARRC.SWORD_AIMLINE.duplicate()
	upgrades_sword_reflection = CONSTARRC.SWORD_REFLECTION.duplicate() + pickAllRandom(CONSTARRC.SWORD_REFLECTION_ROLL_1) + pickAllRandom(CONSTARRC.SWORD_REFLECTION_ROLL_2)
	
	upgrades_artillery_mortar = pickRandom(CONSTARRC.ARTILLERY_MORTAR_HIT_CHOICES) + CONSTARRC.ARTILLERY_ROTATION + pickRandom(CONSTARRC.ARTILLERY_END_CHOICES)
	upgrades_artillery_machinegun = CONSTARRC.ARTILLERY_MACHINEGUN.duplicate() + pickRandom(CONSTARRC.ARTILLERY_MACHINEGUN_CHOICES)
	
	upgrades_tesla_reticlespeed = CONSTARRC.TESLA_RETICLESPEED.duplicate()
	upgrades_tesla_quickshot = CONSTARRC.TESLA_QUICKSHOT.duplicate()
	upgrades_tesla_shotpower = CONSTARRC.TESLA_SHOTPOWER.duplicate() + pickAllRandom(CONSTARRC.TESLA_SHOTPOWER_ROLL1) + pickAllRandom(CONSTARRC.TESLA_SHOTPOWER_ROLL2)
	upgrades_tesla_autoaim = CONSTARRC.TESLA_AUTOAIM.duplicate()
	upgrades_tesla_orb = CONSTARRC.TESLA_ORB_DEFAULT + pickAllRandom(CONSTARRC.TESLA_ORB_ROLL1) + pickAllRandom(CONSTARRC.TESLA_ORB_ROLL2) + pickAllRandom(CONSTARRC.TESLA_ORB_ROLL3)

	upgrades_orchard_duration = CONSTARRC.ORCHARD_DURATION.duplicate()
	upgrades_orchard_overcharge = CONSTARRC.ORCHARD_OVERCHARGE.duplicate()
	upgrades_orchard_special = pickRandom(CONSTARRC.ORCHARD_SPECIAL_CHOICE)
	upgrades_orchard_speedboost = CONSTARRC.ORCHARD_SPEEDBOOST.duplicate()
	upgrades_orchard_miningboost = CONSTARRC.ORCHARD_MININGBOOST.duplicate()

	upgrades_shield_strength = CONSTARRC.SHIELD_STRENGTH.duplicate()
	upgrades_shield_special = pickRandom(CONSTARRC.SHIELD_SPECIAL_CHOICE)
	upgrades_shield_overcharge = CONSTARRC.SHIELD_OVERCHARGE.duplicate() + pickAllRandom(CONSTARRC.SHIELD_OVERCHARGE_ROLL1) + pickAllRandom(CONSTARRC.SHIELD_OVERCHARGE_ROLL2)
	
	upgrades_repellent_delay = CONSTARRC.REPELLENT_DELAY.duplicate()
	upgrades_repellent_special = pickRandom(CONSTARRC.REPELLENT_SPECIAL_CHOICE)
	if upgrades_repellent_special.has("repellentbattleslowdown"):
		upgrades_repellent_special += pickRandom(CONSTARRC.REPELLENT_DEBILITATE_CHOICE)
	upgrades_repellent_overcharge = CONSTARRC.REPELLENT_OVERCHARGE.duplicate() + pickAllRandom(CONSTARRC.REPELLENT_OVERCHARGE_ROLL1) + pickAllRandom(CONSTARRC.REPELLENT_OVERCHARGE_ROLL2)

func getSphereLifetime() -> Array:
	var upgrade = CONSTARRC.KEEPER2_LIFETIME_NAME
	var rtr = []
	for i in range(sphereLifetime):
		rtr.append(upgrade)
	return rtr

func getKeeper1Drills() -> Array:
	var rtr = CONSTARRC.KEEPER1_DRILL.duplicate()
	for i in range(3, drillUpgrades):
		rtr.append("drill4")
	return rtr
	
func getKeeper2Spheres() -> Array:
	var rtr = CONSTARRC.KEEPER2_DAMAGE.duplicate()
	for i in range(3, kineticSphereUpgrades):
		rtr.append("keeper2pinballdamage4")
	return rtr
	
func item_found(itemId: int):
	itemsFoundToProcess.append(itemId)

func processItem(itemId: int) -> String:
	var itemName: String = ""
	
	if itemId == 4242090:
		cobaltRetrieved += 1
		return ""

	match itemId:
		4242000:
			itemName = _getItemNameAndRemove(upgrades_keeper1_drill)
		4242001:
			itemName = _getItemNameAndRemove(upgrades_keeper1_jetpack)
		4242002:
			itemName = _getItemNameAndRemove(upgrades_keeper1_carry)
		4242010:
			itemName = _getItemNameAndRemove(upgrades_keeper2_movement)
		4242011:
			itemName = _getItemNameAndRemove(upgrades_keeper2_damage)
		4242012:
			itemName = _getItemNameAndRemove(upgrades_keeper2_bundle)
		4242013:
			itemName = _getItemNameAndRemove(upgrades_keeper2_more_spheres)
		4242014:
			itemName = _getItemNameAndRemove(upgrades_keeper2_lifetime)
		4242015:
			itemName = _getItemNameAndRemove(upgrades_keeper2_special)
		4242016:
			itemName = _getItemNameAndRemove(upgrades_keeper2_mining)
		4242020:
			itemName = _getItemNameAndRemove(upgrades_laser_strength)
		4242021:
			itemName = _getItemNameAndRemove(upgrades_laser_speed)
		4242022:
			itemName = _getItemNameAndRemove(upgrades_laser_aimline)
		4242030:
			itemName = _getItemNameAndRemove(upgrades_sword_strength)
		4242031:
			itemName = _getItemNameAndRemove(upgrades_sword_aimline)
		4242032:
			itemName = _getItemNameAndRemove(upgrades_sword_stab)
		4242033:
			itemName = _getItemNameAndRemove(upgrades_sword_reflection)
		4242040:
			itemName = _getItemNameAndRemove(upgrades_artillery_mortar)
		4242041:
			itemName = _getItemNameAndRemove(upgrades_artillery_machinegun)
		4242050:
			itemName = _getItemNameAndRemove(upgrades_tesla_reticlespeed)
		4242051:
			itemName = _getItemNameAndRemove(upgrades_tesla_quickshot)
		4242052:
			itemName = _getItemNameAndRemove(upgrades_tesla_shotpower)
		4242053:
			itemName = _getItemNameAndRemove(upgrades_tesla_autoaim)
		4242054:
			itemName = _getItemNameAndRemove(upgrades_tesla_orb)
		4242060:
			itemName = _getItemNameAndRemove(upgrades_repellent_delay)
		4242061:
			itemName = _getItemNameAndRemove(upgrades_repellent_special)
		4242062:
			itemName = _getItemNameAndRemove(upgrades_repellent_overcharge)
		4242070:
			itemName = _getItemNameAndRemove(upgrades_shield_strength)
		4242071:
			itemName = _getItemNameAndRemove(upgrades_shield_special)
		4242072:
			itemName = _getItemNameAndRemove(upgrades_shield_overcharge)
		4242080:
			itemName = _getItemNameAndRemove(upgrades_orchard_duration)
		4242081:
			itemName = _getItemNameAndRemove(upgrades_orchard_overcharge)
		4242082:
			itemName = _getItemNameAndRemove(upgrades_orchard_special)
		4242083:
			itemName = _getItemNameAndRemove(upgrades_orchard_speedboost)
		4242084:
			itemName = _getItemNameAndRemove(upgrades_orchard_miningboost)
		4242100:
			_updateColoredLayers()
			
	GameWorld.buyUpgrade(itemName)
	return itemName

func _updateColoredLayers() -> void:
	coloredLayersUnlocked += 1
	if mapSize == 0 and coloredLayersUnlocked == 2:
		emit_signal("logInformations", "You also unlocked every layers after the third layer.")
		everyLayersUnlockFound = true
	if mapSize == 1 and coloredLayersUnlocked == 3:
		emit_signal("logInformations", "You also unlocked every layers after the fourth layer.")
		everyLayersUnlockFound = true
	if mapSize == 2 and coloredLayersUnlocked == 5:
		emit_signal("logInformations", "You also unlocked every layers after the sixth layer.")
		everyLayersUnlockFound = true
	if mapSize == 3 and coloredLayersUnlocked == 6:
		emit_signal("logInformations", "You also unlocked every layers after the seventh layer.")
		everyLayersUnlockFound = true


func _getItemNameAndRemove(array: Array) -> String:
	if array.size() > 0:
		var returnedValue = array[0]
		array.remove(0)
		return returnedValue
	return ""

func checkUpgrades() -> Array:
	var rtr: Array = []
	while itemsFoundToProcess.size() > 0:
		var processedItem = processItem(itemsFoundToProcess[0])
		itemsFoundToProcess.remove(0)
		rtr.append(processedItem)
	return rtr

func pickAllRandom(array: Array) -> Array:
	var curArray = array.duplicate(true)
	
	var result = []
	var rng = RandomNumberGenerator.new()
	rng.seed = seedNumber
	while curArray.size() > 0:
		var rand_index:int = rng.randi() % curArray.size()
		result.append(curArray[rand_index])
		curArray.remove(rand_index)
	return result

func pickRandom(arrayOfArray: Array) -> Array:
	var rng = RandomNumberGenerator.new()
	rng.seed = seedNumber
	var rand_index:int = rng.randi() % arrayOfArray.size()
	return arrayOfArray[rand_index].duplicate()

func hasLayerUnlocked(layerId: int) -> bool:
	if not coloredLayersProgression:
		return true

	if everyLayersUnlockFound:
		return true
	return layerId <= coloredLayersUnlocked
