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
