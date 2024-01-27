var unlockedUpgrades: Array = []

var lockedUpgrades: Array = []

var keeperUpgrades: Array = []
var domeUpgrades: Array = []
var gadgetUpgrades: Array = []

var keeperUpgradesCount: int = 0
var domeUpgradesCount: int = 0
var gadgetUpgradesCount: int = 0
var keeperUpgradesUnlockedCount: int = 0
var domeUpgradesUnlockedCount: int = 0
var gadgetUpgradesUnlockedCount: int = 0

var cobaltRetrieved: int = 0
var cobaltGiven: int = 0

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

const itemsName: Dictionary = {
	4242004: "Extra cobalt",
	4242010: "Keeper unlock",
	4242030: "Dome unlock",
	4242050: "Primary gadget unlock"
}

const FIRST_SWITCH_ID := 4243101

const TOTAL_SWITCHES_AMOUNT: int = 22

var keeper: String = ""
var dome: String = ""
var primaryGadget: String = ""

var slotName: String = ""
var serverName: String = "archipelago.gg"
var password: String = ""

signal cobalt_given

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func connectClient():
	client.connectToServer(serverName, slotName, password)

func submitSwitch(switch):
	var index = switches.find(switch, 0)
	if index != -1:
		switchesFoundIndexes.append(FIRST_SWITCH_ID + index)
		client.sendLocations(switchesFoundIndexes)

func submitUpgrade(upgradeName):
	var locationId = locationIds.get(upgradeName)
	if locationId != null:
		 client.sendLocation(locationId)

func generateUpgrades():
	generateKeeperUpgrades(client.slotSeed)
	generateDomeUpgrades(client.slotSeed)
	generateGadgetUpgrades(client.slotSeed)
	lockedUpgrades = []
	lockedUpgrades += keeperUpgrades
	lockedUpgrades += domeUpgrades
	lockedUpgrades += gadgetUpgrades
	keeperUpgradesUnlockedCount = 0
	domeUpgradesUnlockedCount = 0
	gadgetUpgradesUnlockedCount = 0
	

func generateKeeperUpgrades(seedNumber):
	if Level.keeperId() == "keeper1":
		keeperUpgrades = CONSTARRC.interleave_arrays(CONSTARRC.KEEPER1_UPGRADES, seedNumber)
	if Level.keeperId() == "keeper2":
		keeperUpgrades = CONSTARRC.interleave_arrays(CONSTARRC.KEEPER2_UPGRADES, seedNumber)

func generateDomeUpgrades(seedNumber):
	if Level.domeId() == "dome1":
		domeUpgrades = CONSTARRC.interleave_arrays(CONSTARRC.LASER_UPGRADES, seedNumber)
	if Level.domeId() == "dome2":
		domeUpgrades = CONSTARRC.interleave_arrays(CONSTARRC.SWORD_UPGRADES, seedNumber)
	if Level.domeId() == "dome3":
		domeUpgrades = CONSTARRC.interleave_arrays(CONSTARRC.ARTILLERY_UPGRADES, seedNumber)
	if Level.domeId() == "dome4":
		domeUpgrades = CONSTARRC.interleave_arrays(CONSTARRC.TESLA_UPGRADES, seedNumber)

func generateGadgetUpgrades(seedNumber):
	if Level.loadout.primaryGadgetId == "shield":
		gadgetUpgrades = CONSTARRC.interleave_arrays(CONSTARRC.SHIELD_UPGRADES, seedNumber)
	if Level.loadout.primaryGadgetId == "repellent":
		gadgetUpgrades = CONSTARRC.interleave_arrays(CONSTARRC.REPELLENT_UPGRADES, seedNumber)
	if Level.loadout.primaryGadgetId == "orchard":
		gadgetUpgrades = CONSTARRC.interleave_arrays(CONSTARRC.ORCHARD_UPGRADES, seedNumber)

func updateUpgradeList(upgrade: String):
	lockedUpgrades.erase(upgrade)
	unlockedUpgrades.append(upgrade)

func unlockKeeperUpgrade():
	var upgrade = keeperUpgrades[0]
	keeperUpgrades.erase(upgrade)
	updateUpgradeList(upgrade)
	return upgrade
	
func unlockDomeUpgrade():
	var upgrade = domeUpgrades[0]
	domeUpgrades.erase(upgrade)
	updateUpgradeList(upgrade)
	return upgrade
	
func unlockGadgetUpgrade():
	var upgrade = gadgetUpgrades[0]
	gadgetUpgrades.erase(upgrade)
	updateUpgradeList(upgrade)
	return upgrade

func checkUpgrades() -> Array:
	var rtr: Array = []
	while keeperUpgradesUnlockedCount < keeperUpgradesCount:
		var upgradeName = unlockKeeperUpgrade()
		keeperUpgradesUnlockedCount += 1
		rtr.append(upgradeName)
	while domeUpgradesUnlockedCount < domeUpgradesCount:
		var upgradeName = unlockDomeUpgrade()
		domeUpgradesCount += 1
		rtr.append(upgradeName)
	while gadgetUpgradesUnlockedCount < gadgetUpgradesCount:
		var upgradeName = unlockGadgetUpgrade()
		gadgetUpgradesUnlockedCount += 1
		rtr.append(upgradeName)
	return rtr
