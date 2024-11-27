extends RefCounted

const ADDITIONNAL_INFOS: String = "Please use the v0.7.1 apworld for bug fixes !"

const SAVE_OPTIONS_ARCHIPELAGO: String = "user://archipelago_options_v2.json"

const ARCHIPELAGOSWITCH: String = "archipelagoswitch"
const TILE_ARCHIPELAGO_SWITCH: int = 4242

const PROTECTED_SPAWNS : Array = [
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

static func isUpgradePurchasable(upgradeName: String) -> bool:
	if (upgradeName == "orchard"
	 or upgradeName == "shield"
	 or upgradeName == "repellent"
	 or upgradeName == "droneyard"
	 or upgradeName == "tesla"
	 or upgradeName == "artillery"
	 or upgradeName == "sword"
	 or upgradeName == "laser"
	 or upgradeName == "drillbot"
	 or upgradeName == "player1.keeper1"
	 or upgradeName == "player1.keeper2"):
		return true
	
	if (upgradeName.begins_with("laser")
	or upgradeName.begins_with("doublelaser")
	or upgradeName.begins_with("sword")
	or upgradeName.begins_with("artillery")
	or upgradeName.begins_with("tesla")
	or upgradeName.begins_with("shield")
	or upgradeName.begins_with("repellent")
	or upgradeName.begins_with("orchard")
	or upgradeName.begins_with("droneyard")
	or upgradeName.begins_with("jetpack")
	or upgradeName.begins_with("drill")
	or upgradeName.begins_with("player1")):
		return false
	return true

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
