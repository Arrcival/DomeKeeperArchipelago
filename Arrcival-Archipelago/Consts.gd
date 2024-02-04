extends Reference

const TILE_ARCHIPELAGO_SWITCH: int = 4242

const KEEPER1_UPGRADES := [
	["drill3", "drill4"],
	["jetpackspeed3", "jetpackspeed4"],
	["jetpackstrength3", "jetpackstrength4"]
]

const KEEPER2_UPGRADES := [
	["keeper2movement3", "keeper2movement4"],
	["keeper2pinballdamage3", "keeper2pinballdamage4"],
	["keeper2bundle3", "keeper2bundle4"],
	["keeper2pinballreflect2"],
	["keeper2pinballexplode2"],
	["keeper2pinballsplit2"],
	["keeper2rotationalmining2"],
]

const LASER_UPGRADES := [
	["laserstrength3", "laserhitprojectiles"],
	["lasermove3"],
	["doublelaser"],
	["laseraimline"],
	["laserbend"],
]

const SWORD_UPGRADES := [
	["swordlargeblade2", "swordlargeblade3"],
	["swordlongblade2", "swordelectrified"],
	["swordstabexplode", "swordstabexplodedamage"],
	["swordaimline"],
	["swordstabshoot"],
	["swordreflection3"],
	["swordexplosivereflection"],
]

const ARTILLERY_UPGRADES := [
	["artillerymachinegunhoming1", "artillerymachinegunhoming2"],
	["artillerymachinegun3", "artillerydoublemachinegun"],
	["artillerydirecthit3", "artillerydirecthit4"],
	["artillerysplash3", "artillerysplash4"],
	["artillerygrenadefastreload"],
	["artilleryrotation2"],
]

const TESLA_UPGRADES := [
	["teslaspeed3", "teslaspeed4"],
	["teslapower3", "teslapower4"],
	["teslatiming1", "teslatiming2"],
	["teslapersistance2", "teslapersistance3", "teslaorbdamage"],
	["teslaquickshot2"],
	["teslaorbstun"],
	["teslaautoaim"],
]

const SHIELD_UPGRADES := [
	["shieldstrength2", "shieldstrength3"],
	["shieldbattlelongerafterdepletion", "shieldbattleblastdamage"],
	["shieldbattleactivateondepletion", "shieldbattledestructionprevention"],
	["shieldbattlereflectshortuses", "shieldbattlereflectspeed"],
	["shieldoverchargeduration1", "shieldoverchargeduration2"],
	["shieldoverchargestrength1", "shieldoverchargestrength2"],
]

const REPELLENT_UPGRADES := [
	["repellentdelay2", "repellentdelay3"],
	["repellentbattlelongerhealthreduction", "repellentbattledamageovertime"],
	["repellentbattlestrongerslowdown1", "repellentbattlestrongerslowdown2"],
	["repellentbattleslowdownstun1", "repellentbattleslowdownstun2"],
	["repellentoverchargeduration1", "repellentoverchargeduration2"],
	["repellentoverchargestrength1", "repellentoverchargestrength2"],
]

const ORCHARD_UPGRADES := [
	["orchardduration2", "orchardduration3"],
	["orchardoverchargebuffduration", "orchardbattlerootingexplosion"],
	["orchardbattlerootingmore", "orchardbattlerootingdigestioninvulnerable"],
	["orchardbattleshieldsecondlayer", "orchardbattleshieldstrong"],
	["orchardjetpack2", "orchardjetpack3"],
	["orcharddrill2", "orcharddrill3"],
]

const KEEPER1_DRILL = ["drill1", "drill2", "drill3", "drill4"]
const KEEPER1_JETPACK = ["jetpackspeed1", "jetpackspeed2", "jetpackspeed3", "jetpackspeed4"]
const KEEPER1_CARRY = ["jetpackstrength1", "jetpackstrength2", "jetpackstrength3", "jetpackstrength4"]

const KEEPER2_MOVEMENT = ["keeper2movement1", "keeper2movement2", "keeper2movement3", "keeper2movement4"]
const KEEPER2_DAMAGE = ["keeper2pinballdamage1", "keeper2pinballdamage2", "keeper2pinballdamage3", "keeper2pinballdamage4"]
const KEEPER2_BUNDLE = ["keeper2bundle1", "keeper2bundle2", "keeper2bundle3", "keeper2bundle4"]
const KEEPER2_MORESPHERES = ["keeper2pinballmorespheres1", "keeper2pinballmorespheres1", "keeper2pinballmorespheres1", "keeper2pinballmorespheres1", "keeper2pinballmorespheres1", "keeper2pinballmorespheres1"]
const KEEPER2_LIFETIME = ["keeper2pinballspherelifetime", "keeper2pinballspherelifetime", "keeper2pinballspherelifetime", "keeper2pinballspherelifetime", "keeper2pinballspherelifetime", "keeper2pinballspherelifetime"]
const KEEPER2_MINING = ["keeper2rotationalmining1", "keeper2rotationalmining2"]
const KEEPER2_SPECIAL_CHOICES := [
	["keeper2pinballreflect", "keeper2pinballreflect2"],
	["keeper2pinballexplode", "keeper2pinballexplode2"],
	["keeper2pinballsplit", "keeper2pinballsplit2"],
]

const LASER_STRENGTH = ["laserstrength1", "laserstrength2"]
const LASER_STRENGTH_ROLL := ["laserstrength3", "doublelaser"]
const LASER_STRENGTH_AFTER_ROLL = ["laserhitprojectiles"]
const LASER_SPEED = ["lasermove1"]
const LASER_SPEED_ROLL := ["lasermove2", "laserbend"]
const LASER_SPEED_AFTER_ROLL := ["lasermove3"]
const LASER_AIMLINE = ["laseraimline"]

const SWORD_STRENGTH = ["swordBlade1"]
const SWORD_STRENGTH_CHOICES := [
	["swordlargeblade1", "swordlargeblade2", "swordlargeblade3"],
	["swordlongblade1", "swordlongblade2", "swordelectrified"],
]
const SWORD_STAB_CHOICES := [
	["swordextendlong1", "swordextendlong2", "swordstabexplode", "swordstabexplodedamage"],
	["swordstabfast1", "swordstabfast2", "swordstabshoot", ""],
]
const SWORD_AIMLINE := ["swordaimline"]
const SWORD_REFLECTION := ["swordreflection1"]
const SWORD_REFLECTION_ROLL_1 := ["swordreflection2", "swordfastreflection"]
const SWORD_REFLECTION_ROLL_2 := ["swordReflection3", "swordexplosivereflection"]

const ARTILLERY_MORTAR_HIT_CHOICES = [
	["artillerydirecthit1", "artillerydirecthit2", "artillerydirecthit3"],
	["artillerysplash1", "artillerysplash2", "artillerysplash3"]
]
const ARTILLERY_ROTATION = ["artilleryrotation1", "artilleryrotation2"]
const ARTILLERY_END_CHOICES = [
	["artillerygrenadefastreload"], ["artillerydirecthit4"], ["artillerysplash4"]
]
const ARTILLERY_MACHINEGUN = ["artillerymachinegun1", "artillerymachinegun2"]
const ARTILLERY_MACHINEGUN_CHOICES = [
	["artillerymachinegun3", "artillerydoublemachinegun"],
	["artillerymachinegunhoming1", "artillerymachinegunhoming2"]
]

const TESLA_RETICLESPEED = ["teslaspeed1", "teslaspeed2", "teslaspeed3", "teslaspeed4"]
const TESLA_QUICKSHOT = ["teslaquickshot", "teslaquickshot2"]
const TESLA_SHOTPOWER = ["teslapower1", "teslapower2"]
const TESLA_SHOTPOWER_ROLL1 = ["teslapower3", "teslatiming1"]
const TESLA_SHOTPOWER_ROLL2 = ["teslapower4", "teslatiming2"]
const TESLA_AUTOAIM = ["teslaautoaim"]
const TESLA_ORB_DEFAULT = ["teslaorbs"]
const TESLA_ORB_ROLL1 = ["teslapersistance1", "teslanurture"]
const TESLA_ORB_ROLL2 = ["teslapersistance2", "teslaorbstun"]
const TESLA_ORB_ROLL3 = ["teslapersistance3", "teslaorbdamage"]

const ORCHARD_DURATION = ["orchardduration1", "orchardduration2", "orchardduration3"]
const ORCHARD_OVERCHARGE = ["orchardovercharge", "orchardoverchargebuffduration"]
const ORCHARD_SPECIAL_CHOICE = [
	["orchardbattlerooting", "orchardbattlerootingexplosion", "orchardbattlerootingmore"],
	["orchardbattleshield", "orchardbattleshieldsecondlayer", "orchardbattleshieldstrong"]
]
const ORCHARD_SPEEDBOOST = ["orchardjetpack1", "orchardjetpack2", "orchardjetpack3"]
const ORCHARD_MININGBOOST = ["orcharddrill1", "orcharddrill2", "orcharddrill3"]

const SHIELD_STRENGTH = ["shieldstrength1", "shieldstrength2", "shieldstrength3"]
const SHIELD_SPECIAL_CHOICE = [
	["shieldbattleelectroblast", "shieldbattlelongerafterdepletion", "shieldbattleblastdamage"],
	["shieldbattleinvulnerable", "shieldbattleactivateondepletion", "shieldbattledestructionprevention"],
	["shieldbattlereflect", "shieldbattlereflectshortuses", "shieldbattlereflectspeed"],
]
const SHIELD_OVERCHARGE = ["shieldovercharge"]
const SHIELD_OVERCHARGE_ROLL1 = ["shieldoverchargeduration1", "shieldoverchargestrength1"]
const SHIELD_OVERCHARGE_ROLL2 = ["shieldoverchargeduration2", "shieldoverchargestrength2"]

const REPELLENT_DELAY = ["repellentdelay1", "repellentdelay2", "repellentdelay3"]
const REPELLENT_SPECIAL_CHOICE = [
	["repellentbattlehealthreduction", "repellentbattlelongerhealthreduction", "repellentbattledamageovertime"],
	["repellentbattleslowdown"],
]
const REPELLENT_DEBILITATE_CHOICE = [
	["repellentbattlestrongerslowdown1", "repellentbattlestrongerslowdown2"],
	["repellentbattleslowdownstun1", "repellentbattleslowdownstun2"]
]
const REPELLENT_OVERCHARGE = ["repellentovercharge"]
const REPELLENT_OVERCHARGE_ROLL1 = ["repellentoverchargeduration1", "repellentoverchargestrength1"]
const REPELLENT_OVERCHARGE_ROLL2 = ["repellentoverchargeduration2", "repellentoverchargestrength2"]


static func isUpgradePurchasable(upgradeName: String) -> bool:
	if (upgradeName == "orchard"
	 or upgradeName == "shield"
	 or upgradeName == "repellent"
	 or upgradeName == "tesla"
	 or upgradeName == "artillery"
	 or upgradeName == "sword"
	 or upgradeName == "laser"
	 or upgradeName == "engineer"
	 or upgradeName == "keeper2"):
		return true
	
	if (upgradeName.begins_with("laser")
	or upgradeName.begins_with("doublelaser")
	or upgradeName.begins_with("sword")
	or upgradeName.begins_with("artillery")
	or upgradeName.begins_with("tesla")
	or upgradeName.begins_with("shield")
	or upgradeName.begins_with("repellent")
	or upgradeName.begins_with("orchard")
	or upgradeName.begins_with("drill")
	or upgradeName.begins_with("jetpack")
	or upgradeName.begins_with("keeper2")):
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
