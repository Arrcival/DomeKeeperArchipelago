class_name ArchipelagoUpgradeGenerator

const CONSTARRC: GDScript = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var slot_data: ArchipelagoSlotData
var upgrade_pools: Dictionary = {}

func setup(slot_data_manager: ArchipelagoSlotData) -> void:
	slot_data = slot_data_manager

func generate() -> Dictionary:
	upgrade_pools = {
		4242000: get_keeper1_drills(),
		4242001: CONSTARRC.KEEPER1_JETPACK.duplicate(),
		4242002: CONSTARRC.KEEPER1_CARRY.duplicate(),
		4242010: CONSTARRC.KEEPER2_MOVEMENT.duplicate(),
		4242011: get_keeper2_spheres(),
		4242012: CONSTARRC.KEEPER2_BUNDLE.duplicate(),
		4242013: CONSTARRC.KEEPER2_MORESPHERES.duplicate(),
		4242014: get_sphere_lifetime(),
		4242015: pick_random(CONSTARRC.KEEPER2_SPECIAL_CHOICES),
		4242016: CONSTARRC.KEEPER2_MINING.duplicate(),
		4242020: CONSTARRC.LASER_STRENGTH.duplicate() + pick_all_random(CONSTARRC.LASER_STRENGTH_ROLL) + CONSTARRC.LASER_STRENGTH_AFTER_ROLL.duplicate(),
		4242021: CONSTARRC.LASER_SPEED.duplicate() + pick_all_random(CONSTARRC.LASER_SPEED_ROLL) + CONSTARRC.LASER_SPEED_AFTER_ROLL.duplicate(),
		4242022: CONSTARRC.LASER_AIMLINE.duplicate(),
		4242030: CONSTARRC.SWORD_STRENGTH.duplicate() + pick_random(CONSTARRC.SWORD_STRENGTH_CHOICES),
		4242031: CONSTARRC.SWORD_AIMLINE.duplicate(),
		4242032: pick_random(CONSTARRC.SWORD_STAB_CHOICES),
		4242033: CONSTARRC.SWORD_REFLECTION.duplicate() + pick_all_random(CONSTARRC.SWORD_REFLECTION_ROLL_1) + pick_all_random(CONSTARRC.SWORD_REFLECTION_ROLL_2),
		4242040: pick_random(CONSTARRC.ARTILLERY_MORTAR_HIT_CHOICES) + CONSTARRC.ARTILLERY_ROTATION + pick_random(CONSTARRC.ARTILLERY_END_CHOICES),
		4242041: CONSTARRC.ARTILLERY_MACHINEGUN.duplicate() + pick_random(CONSTARRC.ARTILLERY_MACHINEGUN_CHOICES),
		4242050: CONSTARRC.TESLA_RETICLESPEED.duplicate(),
		4242051: CONSTARRC.TESLA_QUICKSHOT.duplicate(),
		4242052: CONSTARRC.TESLA_SHOTPOWER.duplicate() + pick_all_random(CONSTARRC.TESLA_SHOTPOWER_ROLL1) + pick_all_random(CONSTARRC.TESLA_SHOTPOWER_ROLL2),
		4242053: CONSTARRC.TESLA_AUTOAIM.duplicate(),
		4242054: CONSTARRC.TESLA_ORB_DEFAULT.duplicate() + pick_all_random(CONSTARRC.TESLA_ORB_ROLL1) + pick_all_random(CONSTARRC.TESLA_ORB_ROLL2) + pick_all_random(CONSTARRC.TESLA_ORB_ROLL3),
		4242060: CONSTARRC.REPELLENT_DELAY.duplicate(),
		4242061: _get_repellent_special(),
		4242062: CONSTARRC.REPELLENT_OVERCHARGE.duplicate() + pick_all_random(CONSTARRC.REPELLENT_OVERCHARGE_ROLL1) + pick_all_random(CONSTARRC.REPELLENT_OVERCHARGE_ROLL2),
		4242070: CONSTARRC.SHIELD_STRENGTH.duplicate(),
		4242071: pick_random(CONSTARRC.SHIELD_SPECIAL_CHOICE),
		4242072: CONSTARRC.SHIELD_OVERCHARGE.duplicate() + pick_all_random(CONSTARRC.SHIELD_OVERCHARGE_ROLL1) + pick_all_random(CONSTARRC.SHIELD_OVERCHARGE_ROLL2),
		4242080: CONSTARRC.ORCHARD_DURATION.duplicate(),
		4242081: CONSTARRC.ORCHARD_OVERCHARGE.duplicate(),
		4242082: pick_random(CONSTARRC.ORCHARD_SPECIAL_CHOICE),
		4242083: CONSTARRC.ORCHARD_SPEEDBOOST.duplicate(),
		4242084: CONSTARRC.ORCHARD_MININGBOOST.duplicate(),
		4242085: get_droneyard_drones(),
		4242086: CONSTARRC.DRONEYARD_SPEED.duplicate(),
		4242087: pick_random(CONSTARRC.DRONEYARD_SPECIAL_CHOICE),
		4242088: CONSTARRC.DRONEYARD_OVERCHARGE.duplicate(),
		4242110: CONSTARRC.INFILTRATOR_CARRY.duplicate(),
		4242111: CONSTARRC.INFILTRATOR_AERIAL.duplicate(),
		4242112: get_infiltrator_mining(),
		4242113: CONSTARRC.INFILTRATOR_COOLDOWN.duplicate(),
		4242114: CONSTARRC.INFILTRATOR_ASSIST.duplicate(),
		4242115: pick_random(CONSTARRC.INFILTRATOR_SHURIKEN_CHOICES),
		4242120: CONSTARRC.BEASTMASTER_SPEED.duplicate(),
		4242121: get_beastmaster_mining(),
		4242122: get_catgoblin_amount(),
		4242123: CONSTARRC.BEASTMASTER_CATGOBLIN_MINING.duplicate(),
		4242124: CONSTARRC.BEASTMASTER_SQUAD_AMOUNT.duplicate(),
		4242125: CONSTARRC.BEASTMASTER_SQUAD_MINING.duplicate(),
	}
	return upgrade_pools

func _get_repellent_special() -> Array[String]:
	var result := pick_random(CONSTARRC.REPELLENT_SPECIAL_CHOICE)
	if result.has("repellentbattleslowdown"):
		result += pick_random(CONSTARRC.REPELLENT_DEBILITATE_CHOICE)
	return result

func get_sphere_lifetime() -> Array[String]:
	return _repeat(CONSTARRC.KEEPER2_LIFETIME_NAME, slot_data.sphereLifetime)

func get_infiltrator_mining() -> Array[String]:
	return _repeat(CONSTARRC.INFILTRATOR_MINING_NAME, slot_data.kunaiUpgrades)

func get_catgoblin_amount() -> Array[String]:
	return _repeat(CONSTARRC.BEASTMASTER_CATGOBLIN_AMOUNT_NAME, slot_data.catgoblinsAmount)

func get_droneyard_drones() -> Array[String]:
	return _repeat(CONSTARRC.DRONEYARD_DRONES_NAME, slot_data.dronesAmount)

func get_keeper1_drills() -> Array[String]:
	var result: Array[String] = CONSTARRC.KEEPER1_DRILL.duplicate()
	for i: int in range(3, slot_data.drillUpgrades):
		result.append("player1.drill4")
	return result

func get_keeper2_spheres() -> Array[String]:
	var result: Array[String] = CONSTARRC.KEEPER2_DAMAGE.duplicate()
	for i: int in range(3, slot_data.kineticSphereUpgrades):
		result.append("player1.keeper2pinballdamage4")
	return result

func get_beastmaster_mining() -> Array[String]:
	var result: Array[String] = pick_random(CONSTARRC.BEASTMASTER_MINING_CHOICE)
	var final_upgrade: String
	if result[0] == CONSTARRC.BEASTMASTER_MINING_CHOICE[0][0]:
		final_upgrade = CONSTARRC.BEASTMASTER_MINING_RAMPING_NAME
	elif result[0] == CONSTARRC.BEASTMASTER_MINING_CHOICE[1][0]:
		final_upgrade = CONSTARRC.BEASTMASTER_MINING_FLEXIBLE_NAME
	else:
		final_upgrade = CONSTARRC.BEASTMASTER_MINING_PUNCH_NAME
	for i: int in range(3, slot_data.beastmasterMiningUpgrades):
		result.append(final_upgrade)
	return result

func _repeat(upgrade: String, amount: int) -> Array[String]:
	var result: Array[String] = []
	for i: int in range(amount):
		result.append(upgrade)
	return result

func pick_all_random(array: Array[String]) -> Array[String]:
	var remaining: Array[String] = array.duplicate(true)
	var result: Array[String] = []
	var rng := RandomNumberGenerator.new()
	rng.seed = slot_data.seedNumber
	while not remaining.is_empty():
		var index := rng.randi() % remaining.size()
		result.append(remaining[index])
		remaining.pop_at(index)
	return result

func pick_random(choices: Array) -> Array[String]:
	var rng := RandomNumberGenerator.new()
	rng.seed = slot_data.seedNumber
	var index := rng.randi() % choices.size()
	var result: Array[String] = []
	result.assign(choices[index].duplicate())
	return result
