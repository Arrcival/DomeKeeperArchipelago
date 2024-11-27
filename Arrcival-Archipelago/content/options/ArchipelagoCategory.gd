extends Node

const CONSTARRC = preload("res://mods-unpacked/Arrcival-Archipelago/Consts.gd")

var json = JSON.new()

var slotNameLineEdit: LineEdit
var serverNameLineEdit: LineEdit
var passwordLineEdit: LineEdit

# port from godot v3
func find_node(value: String) -> Node:
	return find_children(value)[0]
	
func _ready():
	slotNameLineEdit = find_node("SlotName")
	slotNameLineEdit.text = GameWorld.archipelago.slotName
	serverNameLineEdit = find_node("ServerName")
	serverNameLineEdit.text = GameWorld.archipelago.serverName
	passwordLineEdit = find_node("Password")
	passwordLineEdit.text = GameWorld.archipelago.password
	var archipelagoMod = ModLoaderMod.get_mod_data("Arrcival-Archipelago")
	find_node("Version").text = archipelagoMod.manifest.version_number
	find_node("ExtraInfos").text = CONSTARRC.ADDITIONNAL_INFOS
	fix_line_edit(slotNameLineEdit)
	fix_line_edit(serverNameLineEdit)
	fix_line_edit(passwordLineEdit)

func _exit_tree():
	GameWorld.archipelago.slotName = find_node("SlotName").text
	GameWorld.archipelago.serverName = find_node("ServerName").text
	GameWorld.archipelago.password = find_node("Password").text
	
	var dict = generateDictionaryOptions()
	saveArchipelagoOptions(CONSTARRC.SAVE_OPTIONS_ARCHIPELAGO, dict)

func generateDictionaryOptions() -> Dictionary:
	return {
		"slotName": GameWorld.archipelago.slotName,
		"serverName": GameWorld.archipelago.serverName,
		"password": GameWorld.archipelago.password
	}

func saveArchipelagoOptions(path: String, thing_to_save: Dictionary):
	var fileAccess = FileAccess.open(path, FileAccess.WRITE)
	fileAccess.store_string(json.stringify(thing_to_save))
	fileAccess.close()

func fix_line_edit(line_edit: LineEdit) -> void:
	line_edit.focus_entered.connect(_on_line_edit_focus_entered.bind(line_edit))

func _on_line_edit_focus_entered(line_edit: LineEdit) -> void:
	# get the cancel events now just in case they were rebound inbetween
	var cancel_events := InputMap.action_get_events(&"ui_cancel")
	line_edit.focus_exited.connect(restore_ui_cancel_keybinds.bind(cancel_events))
	
	# We always want at least one ui element to have focus to not break controllers,
	# so removing all binds to defocus is fine
	InputMap.action_erase_events(&"ui_cancel")


func restore_ui_cancel_keybinds(input_events: Array[InputEvent]) -> void:
	for event in input_events:
		InputMap.action_add_event(&"ui_cancel", event)
