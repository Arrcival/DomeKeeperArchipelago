extends Node

const MYMODNAME_MOD_DIR = "Arrcival-Archipelago/"
const MYMODNAME_LOG = "Arrcival-Archipelago"

const EXTENSIONS_DIR = "extensions/"
const HOOKS_DIR = "hooks/"

func _init(modLoader = ModLoader):
	ModLoaderLog.info("init starting", MYMODNAME_LOG)
	var dir = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR
	var ext_dir = dir + EXTENSIONS_DIR
	var hooks_dir = dir + HOOKS_DIR
	
	# Add extensions
	loadExtension(ext_dir, "Audio.gd")
	loadExtension(ext_dir, "ArtifactDropPoint.gd")
	loadExtension(ext_dir, "AssignmentChoice.gd")
	loadExtension(ext_dir, "Data.gd")
	loadExtension(ext_dir, "GameWorld.gd")
	loadExtension(ext_dir, "Keeper2.gd")
	loadExtension(ext_dir, "PauseMenu.gd")
	loadExtension(ext_dir, "RelicDropPoint.gd")
	loadExtension(ext_dir, "RelicHunt.gd")
	loadExtension(ext_dir, "RunFinishedPopup.gd")
	#loadExtension(ext_dir, "SaveGame.gd")
	loadExtension(ext_dir, "StageManager.gd")
	loadExtension(ext_dir, "TileDataGenerator.gd")
	loadExtension(ext_dir, "TitleStage.gd")
	
	loadHook("res://content/map/tile/Tile.gd", hooks_dir, "Tile.hooks.gd")
	loadHook("res://content/map/Map.gd", hooks_dir, "Map.hooks.gd")
	loadHook("res://content/monster/Monsters.gd", hooks_dir, "Monsters.hooks.gd")
	
	ModLoaderMod.add_translation(dir + "localization/archipelago.en.translation")
	
	ModLoaderLog.info("init done", MYMODNAME_LOG)

func _ready():
	ModLoaderLog.info("_ready starting", MYMODNAME_LOG)
	add_to_group("mod_init")
	archipelagoInit()
	ModLoaderLog.info("_ready done", MYMODNAME_LOG)

func loadExtension(ext_dir, fileName):
	ModLoaderMod.install_script_extension(ext_dir + fileName)

func loadHook(vanilla_class, hooks_dir, fileName):
	ModLoaderMod.install_script_hooks(vanilla_class, hooks_dir + fileName)

func modInit():
	var levelStage = preload("res://mods-unpacked/Arrcival-Archipelago/content/levelstage/APLevelStage.tscn")
	levelStage.take_over_path("res://stages/level/LevelStage.tscn")
	var techTree = preload("res://mods-unpacked/Arrcival-Archipelago/content/techtree/APTechTreePopup.tscn")
	techTree.take_over_path("res://content/techtree/TechTreePopup.tscn")
	var pathToModYaml : String = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR + "yaml/"
	Data.parseUpgradesYaml(pathToModYaml + "upgrades.yaml")
	

func archipelagoInit():
	# Magic strings cause magic godot
	Data.DROP_SCENES["charm"] = preload("res://mods-unpacked/Arrcival-Archipelago/content/charm/CharmDrop.tscn")
