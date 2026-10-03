extends Node

const MYMODNAME_MOD_DIR = "Arrcival-Archipelago/"
const MYMODNAME_LOG = "Arrcival-Archipelago"

const EXTENSIONS_DIR = "extensions/"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

func _init(modLoader = ModLoader):
	ModLoaderLog.info("init starting", MYMODNAME_LOG)
	var dir = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR
	var ext_dir = dir + EXTENSIONS_DIR

	# Add extensions
	loadExtension(ext_dir, "Audio.gd")
	loadExtension(ext_dir, "ArtifactDropPoint.gd")
	loadExtension(ext_dir, "AssignmentChoice.gd")
	loadExtension(ext_dir, "GameWorld.gd")
	loadExtension(ext_dir, "Keeper1.gd")
	loadExtension(ext_dir, "Keeper2.gd")
	#loadExtension(ext_dir, "Keeper4.gd") # Could not resolve class?
	loadExtension(ext_dir, "Kunai.gd")
	loadExtension(ext_dir, "LevelStage.gd")
	loadExtension(ext_dir, "Map.gd")
	loadExtension(ext_dir, "Monsters.gd")
	loadExtension(ext_dir, "MultiplayerLoadoutStage.gd")
	#loadExtension(ext_dir, "PauseMenu.gd") # Could not resolve class?
	loadExtension(ext_dir, "Pinball.gd")
	loadExtension(ext_dir, "RelicDropPoint.gd")
	loadExtension(ext_dir, "Relichunt.gd")
	loadExtension(ext_dir, "RunFinishedPopup.gd")
	loadExtension(ext_dir, "StageManager.gd")
	loadExtension(ext_dir, "Tech2.gd")
	loadExtension(ext_dir, "TechTreePopup.gd")
	loadExtension(ext_dir, "Tile.gd")
	loadExtension(ext_dir, "TileDataGenerator.gd")
	loadExtension(ext_dir, "TitleStage.gd")

	ModLoaderMod.add_translation(dir + "localization/archipelago.en.translation")
	
	ModLoaderLog.info("init done", MYMODNAME_LOG)

func _ready():
	ModLoaderLog.info("_ready starting", MYMODNAME_LOG)
	add_to_group("mod_init")
	archipelagoInit()
	ModLoaderLog.info("_ready done", MYMODNAME_LOG)

func loadExtension(ext_dir, fileName):
	ModLoaderMod.install_script_extension(ext_dir + fileName)

func modInit():
	var pathToModYaml : String = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR + "yaml/"
	Data.parseUpgradesYaml(pathToModYaml + "upgrades.yaml")

	# move archipelago to reach always the top tab
	var index :int = Data.orderedUpgradeKeys.find("archipelago")
	if index != -1:
		Data.orderedUpgradeKeys.remove_at(index)
		Data.orderedUpgradeKeys.push_front("archipelago")

func archipelagoInit():
	Data.DROP_TYPES.append(CONSTARRC.AP_TREASURE)
	Data.DROP_SCENES[CONSTARRC.AP_TREASURE] = preload("res://mods-unpacked/Arrcival-Archipelago/content/treasure/APTreasureDrop.tscn")
