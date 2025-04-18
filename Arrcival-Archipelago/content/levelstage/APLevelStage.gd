extends LevelStage

func _ready():
	super._ready()
	GameWorld.archipelago.client.onDeathFound.connect(self.makeUserLose)

func _process(deltaTime: float):
	super._process(deltaTime)
	# Process upgrade in frame per frame basis
	# Unwinds the upgrades retrieved to avoid locks
	var upgrades: Array = GameWorld.archipelago.checkUpgrades()
	if upgrades.size() > 0:
		var tree = get_tree()
		if tree != null:
			var nodes = tree.get_nodes_in_group("techpanel")
			if nodes != null and nodes.size() > 0:
				for node in nodes:
					if upgrades.has(node.techId):
						node.reactivate()

	# Unwinds ressources received to add in inventory
	if GameWorld.archipelago.cobaltGiven < GameWorld.archipelago.cobaltRetrieved:
		Data.changeByInt("inventory.sand", GameWorld.archipelago.cobaltRetrieved - GameWorld.archipelago.cobaltGiven)
		GameWorld.archipelago.cobaltGiven = GameWorld.archipelago.cobaltRetrieved
	
	if GameWorld.archipelago.waterGiven < GameWorld.archipelago.waterRetrieved:
		Data.changeByInt("inventory.water", GameWorld.archipelago.waterRetrieved - GameWorld.archipelago.waterGiven)
		GameWorld.archipelago.waterGiven = GameWorld.archipelago.waterRetrieved
		
	if GameWorld.archipelago.ironGiven < GameWorld.archipelago.ironRetrieved:
		Data.changeByInt("inventory.iron", GameWorld.archipelago.ironRetrieved - GameWorld.archipelago.ironGiven)
		GameWorld.archipelago.ironGiven = GameWorld.archipelago.ironRetrieved
	
	if GameWorld.archipelago.cobaltGivenGA < GameWorld.archipelago.cobaltRetrievedGA:
		Data.changeByInt("inventory.sand", GameWorld.archipelago.cobaltRetrievedGA - GameWorld.archipelago.cobaltGivenGA)
		GameWorld.archipelago.cobaltGivenGA = GameWorld.archipelago.cobaltRetrievedGA
	
	if GameWorld.archipelago.waterGivenGA < GameWorld.archipelago.waterRetrievedGA:
		Data.changeByInt("inventory.water", GameWorld.archipelago.waterRetrievedGA - GameWorld.archipelago.waterGivenGA)
		GameWorld.archipelago.waterGivenGA = GameWorld.archipelago.waterRetrievedGA
	
	if GameWorld.archipelago.ironGivenGA < GameWorld.archipelago.ironRetrievedGA:
		Data.changeByInt("inventory.iron", GameWorld.archipelago.ironRetrievedGA - GameWorld.archipelago.ironGivenGA)
		GameWorld.archipelago.ironGivenGA = GameWorld.archipelago.ironRetrievedGA

# Kill the user on death link with standard death behavior
func makeUserLose():
	GameWorld.archipelago.died_to_death_link = true
	Data.changeDomeHealth(-999999)

func beforeStart():
	super.beforeStart()
	if GameWorld.archipelago.isRHMode():
		GameWorld.archipelago.scoutUpgrades()

# copy paste but with new TechTreePopup
func startUpgradesInput(keeper:Keeper):
	var i = preload("res://stages/level/UpgradesInputProcessor.gd").new()
	i.deviceId = Keepers.getDeviceId(keeper.playerId)
	inputDeviceLimit = i.deviceId
	var techTreePopup = preload("res://mods-unpacked/Arrcival-Archipelago/content/techtree/APTechTreePopup.tscn").instantiate()
	techTreePopup.addPrefixMapping(keeper.techId, keeper.playerId)
	find_child("TechtreeContainer").add_child(techTreePopup)
	i.popup = techTreePopup
	i.connect("buyUpgrade", Callable(techTreePopup, "buyUpgrade"))
	i.connect("onStop", Callable(self, "set").bind("inputDeviceLimit", -1))
	i.integrate(self)
