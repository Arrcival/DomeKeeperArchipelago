extends RefCounted

const MOD_ID: String = "Arrcival-Archipelago"

const ADDITIONNAL_INFOS: String = "Please use the latest apworld in the AP discord !"

const ARCHIPELAGOSWITCH: String = "archipelagoswitch"
const TILE_ARCHIPELAGO_SWITCH: int = 4242

const SECONDS_LOST_PER_TRAP: int = 15

const TILE_CHAMBER = 77
const CHAMBER = "chamber"

const ARTIFACT = "artifact"

const PROTECTED_SPAWNS : Array[Vector2] = [
	Vector2(0, 0),
	Vector2(0, 1),
	Vector2(0, 2),
	Vector2(0, 3),
	Vector2(-1, 0),
	Vector2(-1, 1),
	Vector2(-1, 2),
	Vector2(1, 0),
	Vector2(1, 1),
	Vector2(1, 2)
]

#region Upgrade names
const KEEPER1_DRILL: Array[String] = ["player1.drill1", "player1.drill2", "player1.drill3"]
const KEEPER1_JETPACK: Array[String] = ["player1.jetpackspeed1", "player1.jetpackspeed2", "player1.jetpackspeed3", "player1.jetpackspeed4"]
const KEEPER1_CARRY: Array[String] = ["player1.jetpackstrength1", "player1.jetpackstrength2", "player1.jetpackstrength3", "player1.jetpackstrength4"]

const KEEPER2_MOVEMENT: Array[String] = ["player1.keeper2movement1", "player1.keeper2movement2", "player1.keeper2movement3", "player1.keeper2movement4"]
const KEEPER2_DAMAGE: Array[String] = ["player1.keeper2pinballdamage1", "player1.keeper2pinballdamage2", "player1.keeper2pinballdamage3"]
const KEEPER2_BUNDLE: Array[String] = ["player1.keeper2bundle1", "player1.keeper2bundle2", "player1.keeper2bundle3", "player1.keeper2bundle4"]
const KEEPER2_MORESPHERES: Array[String] = ["player1.keeper2pinballmorespheres1", "player1.keeper2pinballmorespheres1", "player1.keeper2pinballmorespheres1", "player1.keeper2pinballmorespheres1", "player1.keeper2pinballmorespheres1", "player1.keeper2pinballmorespheres1"]
const KEEPER2_LIFETIME_NAME: String = "player1.keeper2pinballspherelifetime"
const KEEPER2_MINING: Array[String] = ["player1.keeper2rotationalmining1", "player1.keeper2rotationalmining2"]
const KEEPER2_SPECIAL_CHOICES: Array = [
	["player1.keeper2pinballreflect", "player1.keeper2pinballreflect2"],
	["player1.keeper2pinballexplode", "player1.keeper2pinballexplode2"],
	["player1.keeper2pinballsplit", "player1.keeper2pinballsplit2"],
]

const INFILTRATOR_CARRY: Array[String] = ["player1.keeper3carrylimit1", "player1.keeper3carrylimit2", "player1.keeper3carrylimit3"]
const INFILTRATOR_AERIAL: Array[String] = ["player1.keeper3doublejump", "player1.keeper3slidecontrol", "player1.keeper3quadjump", "player1.keeper3aerialmastery"]
const INFILTRATOR_MINING_NAME: String = "keeper3kunaidamage4"
const INFILTRATOR_COOLDOWN: Array[String] = ["player1.keeper3kunaicooldown1", "player1.keeper3kunaicooldown2", "player1.keeper3kunaicooldown3"]
const INFILTRATOR_ASSIST: Array[String] = ["player1.keeper3kunaibounce1", "player1.keeper3kunaibounce2"]
const INFILTRATOR_SHURIKEN_CHOICES: Array = [
	["player1.keeper3shuriken1", "player1.keeper3shuriken2", "player1.keeper3shurikencooldown1", "player1.keeper3shurikencooldown2"],
	["player1.keeper3shuriken1", "player1.keeper3shuriken2", "player1.keeper3shurikenstrength1", "player1.keeper3shurikenstrength2"]
	]

const BEASTMASTER_SPEED: Array[String] = ["player1.keeper4speed1", "player1.keeper4speed2", "player1.keeper4speed3"]
const BEASTMASTER_MINING_CHOICE: Array = [
	["player1.keeper4ramping1", "player1.keeper4ramping2", "player1.keeper4ramping3"],
	["player1.keeper4flexible1", "player1.keeper4flexible2", "player1.keeper4flexible3"],
	["player1.keeper4punch1", "player1.keeper4punch2", "player1.keeper4punch3"],
]
const BEASTMASTER_MINING_RAMPING_NAME: String = "player1.keeper4ramping4"
const BEASTMASTER_MINING_FLEXIBLE_NAME: String = "player1.keeper4flexible4"
const BEASTMASTER_MINING_PUNCH_NAME: String = "player1.keeper4punch4"

const BEASTMASTER_CATGOBLIN_AMOUNT_NAME: String = "keeper4catgoblinamount"
const BEASTMASTER_CATGOBLIN_MINING: Array[String] = ["player1.keeper4catgoblindig1", "player1.keeper4catgoblindig2", "player1.keeper4catgoblinsleeptime"]
const BEASTMASTER_SQUAD_AMOUNT: Array[String] = ["player1.keeper4squad1", "player1.keeper4squad1", "player1.keeper4squad1"]
const BEASTMASTER_SQUAD_MINING: Array[String] = ["player1.keeper4autospawnminers", "player1.keeper4squad2", "player1.keeper4squad3"]

const LASER_STRENGTH: Array[String] = ["laserstrength1", "laserstrength2"]
const LASER_STRENGTH_ROLL: Array[String] = ["laserstrength3", "laserhitprojectiles"]
const LASER_STRENGTH_AFTER_ROLL: Array[String] = ["laserstrength4"]
const LASER_SPEED: Array[String] = ["lasermove1"]
const LASER_SPEED_ROLL: Array[String] = ["lasermove2", "laserbend"]
const LASER_SPEED_AFTER_ROLL: Array[String] = ["lasermove3"]
const LASER_AIMLINE: Array[String] = ["laseraimline"]

const SWORD_STRENGTH: Array[String] = ["swordblade1"]
const SWORD_STRENGTH_CHOICES: Array = [
	["swordlargeblade1", "swordlargeblade2", "swordlargeblade3"],
	["swordlongblade1", "swordlongblade2", "swordelectrified"],
]
const SWORD_STAB_CHOICES: Array = [
	["swordextendlong1", "swordextendlong2", "swordstabexplode", "swordstabexplodedamage"],
	["swordstabfast1", "swordstabfast2", "swordstabshoot", ""],
]
const SWORD_AIMLINE: Array[String] = ["swordaimline"]
const SWORD_REFLECTION: Array[String] = ["swordreflection1"]
const SWORD_REFLECTION_ROLL_1: Array[String] = ["swordreflection2", "swordfastreflection"]
const SWORD_REFLECTION_ROLL_2: Array[String] = ["swordreflection3", "swordexplosivereflection"]

const ARTILLERY_MORTAR_HIT_CHOICES: Array = [
	["artillerydirecthit1", "artillerydirecthit2", "artillerydirecthit3"],
	["artillerysplash1", "artillerysplash2", "artillerysplash3"]
]
const ARTILLERY_ROTATION: Array[String] = ["artilleryrotation1", "artilleryrotation2"]
const ARTILLERY_END_CHOICES: Array = [
	["artillerygrenadefastreload"], ["artillerydirecthit4"], ["artillerysplash4"]
]
const ARTILLERY_MACHINEGUN: Array[String] = ["artillerymachinegun1", "artillerymachinegun2"]
const ARTILLERY_MACHINEGUN_CHOICES: Array = [
	["artillerymachinegun3", "artillerydoublemachinegun"],
	["artillerymachinegunhoming1", "artillerymachinegunhoming2"]
]

const TESLA_RETICLESPEED: Array[String] = ["teslaspeed1", "teslaspeed2", "teslaspeed3", "teslaspeed4"]
const TESLA_QUICKSHOT: Array[String] = ["teslaquickshot", "teslaquickshot2"]
const TESLA_SHOTPOWER: Array[String] = ["teslapower1", "teslapower2"]
const TESLA_SHOTPOWER_ROLL1: Array[String] = ["teslapower3", "teslatiming1"]
const TESLA_SHOTPOWER_ROLL2: Array[String] = ["teslapower4", "teslatiming2"]
const TESLA_AUTOAIM: Array[String] = ["teslaautoaim"]
const TESLA_ORB_DEFAULT: Array[String] = ["teslaorbs"]
const TESLA_ORB_ROLL1: Array[String] = ["teslapersistance1", "teslanurture"]
const TESLA_ORB_ROLL2: Array[String] = ["teslapersistance2", "teslaorbstun"]
const TESLA_ORB_ROLL3: Array[String] = ["teslapersistance3", "teslaorbdamage"]

const ORCHARD_DURATION: Array[String] = ["orchardduration1", "orchardduration2", "orchardduration3"]
const ORCHARD_OVERCHARGE: Array[String] = ["orchardovercharge", "orchardoverchargebuffduration"]
const ORCHARD_SPECIAL_CHOICE: Array = [
	["orchardbattlerooting", "orchardbattlerootingexplosion", "orchardbattlerootingmore"],
	["orchardbattleshield", "orchardbattleshieldsecondlayer", "orchardbattleshieldstrong"]
]
const ORCHARD_SPEEDBOOST: Array[String] = ["orchardjetpack1", "orchardjetpack2", "orchardjetpack3"]
const ORCHARD_MININGBOOST: Array[String] = ["orcharddrill1", "orcharddrill2", "orcharddrill3"]

const SHIELD_STRENGTH: Array[String] = ["shieldstrength1", "shieldstrength2", "shieldstrength3"]
const SHIELD_SPECIAL_CHOICE: Array = [
	["shieldbattleelectroblast", "shieldbattlelongerafterdepletion", "shieldbattleblastdamage"],
	["shieldbattlereflect", "shieldbattlereflectshortuses", "shieldbattlereflectspeed"],
	["shieldbattleinvulnerable", "shieldbattleactivateondepletion", "shieldbattledestructionprevention"]
]
const SHIELD_OVERCHARGE: Array[String] = ["shieldovercharge"]
const SHIELD_OVERCHARGE_ROLL1: Array[String] = ["shieldoverchargeduration1", "shieldoverchargestrength1"]
const SHIELD_OVERCHARGE_ROLL2: Array[String] = ["shieldoverchargeduration2", "shieldoverchargestrength2"]

const REPELLENT_DELAY: Array[String] = ["repellentdelay1", "repellentdelay2", "repellentdelay3"]
const REPELLENT_SPECIAL_CHOICE: Array = [
	["repellentbattlehealthreduction", "repellentbattlelongerhealthreduction", "repellentbattledamageovertime"],
	["repellentbattleslowdown"],
]
const REPELLENT_DEBILITATE_CHOICE: Array = [
	["repellentbattlestrongerslowdown1", "repellentbattlestrongerslowdown2"],
	["repellentbattleslowdownstun1", "repellentbattleslowdownstun2"]
]
const REPELLENT_OVERCHARGE: Array[String] = ["repellentovercharge"]
const REPELLENT_OVERCHARGE_ROLL1: Array[String] = ["repellentoverchargeduration1", "repellentoverchargestrength1"]
const REPELLENT_OVERCHARGE_ROLL2: Array[String] = ["repellentoverchargeduration2", "repellentoverchargestrength2"]

const DRONEYARD_DRONES_NAME: String = "droneyarddrones"
const DRONEYARD_SPEED: Array[String] = ["droneyarddronespeed1", "droneyarddronespeed1", "droneyarddronespeed1", "droneyarddronespeed1", "droneyarddronespeed1"]
const DRONEYARD_SPECIAL_CHOICE: Array = [
	["droneyardbattlegrid", "droneyardbattlegridquick1", "droneyardbattlegridquick2"],
	["droneyardbattlegrid", "droneyardbattlegridlong1", "droneyardbattlegridlong2"],
	["droneyardparasites", "droneyardparasites2", "droneyardparasites3"],
]
const DRONEYARD_OVERCHARGE: Array[String] = ["droneyardovercharge1", "droneyardovercharge2", "droneyardovercharge3"]
#endregion

const PURCHASABLE_UPGRADES: Array[String] = [
	"orchard", "shield", "repellent", "droneyard", 
	"tesla", "artillery", "sword", "laser", "drillbot", 
	"player1.keeper1", "player1.keeper2", "drill"
]

const UNPURCHASABLE_UPGRADES_STARTSWITH: Array[String] = [
	"laser", "doublelaser", "sword", "artillery", "tesla", 
	"shield", "repellent", "orchard", "droneyard", "jetpack",
	"player1"
]

const UNPURCHASABLE_UPGRADES: Array[String] = [
	"drill1", "drill2", "drill3", "drill4"
]

static func is_upgrade_purchasable(upgradeName: String) -> bool:
	if PURCHASABLE_UPGRADES.has(upgradeName):
		return true

	if UNPURCHASABLE_UPGRADES.has(upgradeName):
		return false

	for prefix in UNPURCHASABLE_UPGRADES_STARTSWITH:
		if upgradeName.begins_with(prefix):
			return false

	return true

const ASSIGNMENTS_DEFAULT_EMPTY: Dictionary = {
	"showdown": false,
	"ironcontribution": false,
	"inversegravity": false,
	"maze": false,
	"projectilehell": false,
	"denseiron": false,
	"bigmapsparseresources": false,
	"weapondefect": false,
	"heavyhitters": false,
	"superhardrockwithholes": false,
	"weakcarry": false,
	"weakwalls": false,
	"monstermasses": false,
	"rareiron": false,
	"weakmining": false,
	"cobaltcontribution": false,
	"minorvision": false, # Darkness?
	"acidrain": false,
	"treefarm": false,
	"megacreeps": false,
	"instagip": false,
	"harmfuliron" : false, # Hazardous Iron
	"emergency" : false,
	"logistics" : false,
	"unpredictable": false
}

const ASSIGNMENTS_LIST : Array[String] = [
	"showdown", "ironcontribution", "inversegravity", "maze", 
	"projectilehell", "denseiron", "bigmapsparseresources", "weapondefect", 
	"heavyhitters", "superhardrockwithholes", "weakcarry", "weakwalls", 
	"monstermasses", "rareiron", "weakmining", "cobaltcontribution",
	"minorvision", "acidrain", "treefarm", "megacreeps", "instagip", "harmfuliron",
	"emergency", "logistics", "unpredictable"
]

# Recupère l'index du prochain array à récupérer la valeur, en se basant sur le nombre d'elements total dans tous les arrays
static func make_array_choice(arrays: Array, total_elements: int, rng: RandomNumberGenerator) -> int:
	# Génère un nombre aléatoire correspondant à la position d'un élément dans l'array global s'il était aplati
	var element_choice: int = rng.randi_range(0, total_elements - 1)
	
	var element_count: int = 0
	for index in range(len(arrays)):
		element_count += arrays[index].size()
		if element_choice < element_count:
			return index
	return -1 # Should never happen

# Intercale les arrays en utilisant une graine (seed)
static func interleave_arrays(arrays: Array, seedNumber: int) -> Array:
	var rng = RandomNumberGenerator.new()
	rng.seed = seedNumber

	var element_count: int = 0
	for sub_arr in arrays:
		element_count += sub_arr.size()

	# Crée une copie pour éviter de modifier l'array original
	var arr_copy: Array = arrays.duplicate(true)

	var resultat: Array = []

	while element_count > 0:
		# Récupère l'index de l'array où le premier élément sera choisi
		var array_choice_idx: int = make_array_choice(arr_copy, element_count, rng)

		# On récupère la valeur (en la retirant de l'array choisi) et on l'ajoute à l'array de resultat
		resultat.append(arr_copy[array_choice_idx].pop_front())

		element_count -= 1

	return resultat
