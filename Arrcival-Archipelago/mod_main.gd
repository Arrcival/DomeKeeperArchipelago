extends Node

const MYMODNAME_MOD_DIR = "Arrcival-Archipelago/"
const MYMODNAME_LOG = "Arrcival-Archipelago"

const EXTENSIONS_DIR = "extensions/"

func _init(modLoader = ModLoader):
	ModLoaderLog.info("init starting", MYMODNAME_LOG)
	var dir = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR
	var ext_dir = dir + EXTENSIONS_DIR
	
	# Add extensions
	loadExtension(ext_dir, "Data.gd")
	loadExtension(ext_dir, "GameWorld.gd")
	loadExtension(ext_dir, "RelicDropPoint.gd")
	loadExtension(ext_dir, "RelicHunt.gd")
	loadExtension(ext_dir, "StageManager.gd")
	loadExtension(ext_dir, "TileDataGenerator.gd")
	loadExtension(ext_dir, "TitleStage.gd")
	
	ModLoaderMod.add_translation(dir + "localization/archipelago.en.translation")
	
	ModLoaderLog.info("init done", MYMODNAME_LOG)

func _ready():
	ModLoaderLog.info("_ready starting", MYMODNAME_LOG)
	add_to_group("mod_init")
	ModLoaderLog.info("_ready done", MYMODNAME_LOG)

func loadExtension(ext_dir, fileName):
	ModLoaderMod.install_script_extension(ext_dir + fileName)

func modInit():
	var levelStage = preload("res://mods-unpacked/Arrcival-Archipelago/content/levelstage/LevelStage2.tscn")
	levelStage.take_over_path("res://stages/level/LevelStage.tscn")
	var techTree = preload("res://mods-unpacked/Arrcival-Archipelago/content/techtree/APTechTreePopup.tscn")
	techTree.take_over_path("res://content/techtree/TechTreePopup.tscn")
	var pathToModYaml : String = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR + "yaml/"
	Data.parseUpgradesYaml(pathToModYaml + "upgrades.yaml")
	
