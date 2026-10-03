extends Node

const MOD_ICON_PATH := "res://mods-unpacked/Arrcival-Archipelago/content/icons/upgrades/"
const GAME_ICON_PATH := "res://content/icons/"

var icons := [
    "wormsindicator.png"
]

var iconTextures := []

func _init() -> void:
	print("Trying to open directory %s" % MOD_ICON_PATH)
	var dir := DirAccess.open(MOD_ICON_PATH)

	if dir == null: 
		printerr("Could not open folder")
		return

	for file: String in dir.get_files():
		if not file.ends_with(".png"):
			continue

		var file_path = dir.get_current_dir() + "/" + file
		print("Loading file %s" % file_path)

		var overwrite := load(file_path)
		iconTextures.append(overwrite)
		overwrite.take_over_path(GAME_ICON_PATH + file)