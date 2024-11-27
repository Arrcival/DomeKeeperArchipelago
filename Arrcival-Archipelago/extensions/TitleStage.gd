extends "res://stages/title/TitleStage.gd"

var archipelago_options_scene = load("res://mods-unpacked/Arrcival-Archipelago/content/options/ArchipelagoCategory.tscn")

var connectButton: Button
var newGameButton: Button

var shouldDisconnect = false

func build(data: Array):
	newGameButton = find_child("NewGameButton")
	newGameButton.disabled = true
	connectButton = Button.new()
	connectButton.name = "ConnectButton"
	connectButton.text = "Connect"
	
	connectButton.pressed.connect(self.connect_archipelago)
	
	add_child_first(find_child("AdditionalButtons"), connectButton)
	super.build(data)

	var continueButton = find_child("ContinueButton")
	continueButton.disabled = true
	continueButton.visible = false
	
	var moddingButton: Control = find_child("ModdingButton")
	moddingButton.set_focus_neighbor(Side.SIDE_TOP, NodePath(connectButton.get_path()))
	
	var prestigeButton = find_child("ToggleBoardButton")
	connectButton.set_focus_neighbor(Side.SIDE_TOP, NodePath(prestigeButton.get_path()))
	
	GameWorld.archipelago.client.slot_data_have_been_retrieved.connect(self.onArchipelagoConnected)
	GameWorld.archipelago.client.could_not_connect.connect(self.onArchipelagoFailure)

	# so hovering prestige from connect goes back to connect when pressing down
	if GameWorld.isUnlocked(CONST.MODE_PRESTIGE):
		var prestigeNode = find_child("PrestigeMenu")
		moddingButton.disconnect("focus_entered", Callable(prestigeNode, "on_mainmenu_button_focussed").bind(moddingButton))
		connectButton.connect("focus_entered", Callable(prestigeNode, "on_mainmenu_button_focussed").bind(connectButton))
	

	# in case of coming back from new game to the main menu
	if GameWorld.archipelago.client.is_client_connected():
		onArchipelagoConnected()
		
	InputSystem.grabFocus(connectButton)

func _on_OptionsButton_pressed() -> void:
	Audio.sound("gui_title_options")
	var i = preload("res://systems/options/OptionsInputProcessor.gd").new()
	i.blockAllKeys = true
	var options_panel = preload("res://systems/options/OptionsPanel.tscn").instantiate()
	
	# Archipelago
	var archipelago_button = Button.new()
	archipelago_button.text = "Archipelago"
	# Must be called xxxCategoryButton
	archipelago_button.set_name("ArchipelagoCategoryButton")
	archipelago_button.pressed.connect(options_panel._on_CategoryButton_pressed.bind("Archipelago"))
	options_panel.categories.push_back("Archipelago")
	options_panel.find_child("CategoriesList").add_child(archipelago_button)
	archipelago_button.owner = options_panel
	
	var archipelago_category = archipelago_options_scene.instantiate()
	# Must be called xxxCategory
	archipelago_category.set_name("ArchipelagoCategory")
	# Appending the category to the container list
	options_panel.find_child("MarginContainer").add_child(archipelago_category)
	archipelago_category.owner = options_panel

	i.popup = options_panel
	i.stickReceiver = i.popup
	$Canvas.add_child(i.popup)
	i.popup.setFromOptions()
	i.integrate(self)
	i.connect("onStop", Callable(self, "optionsClosed").bind(i.popup))
	i.popup.connect("close", Callable(i, "desintegrate"))
	find_child("Overlay").showOverlay()

func moveMenuIn(delay: = defaultDelay):
	super.moveMenuIn(delay)
	find_child("ContinueButton").hide()
	$Tween.interpolate_callback(InputSystem, delay + 0.5 * moveDuration, "grabFocus", find_child("NewGameButton"))
	find_child("NewGameButton").focus_neighbor_left = find_child("CreditsButton").get_path()

func add_child_first(node: Node, child: Node):
	node.add_child(child)
	node.move_child(child, 0)

func connect_archipelago():
	connectButton.text = "Connecting..."
	if !shouldDisconnect:
		GameWorld.archipelago.connectClient()
	else:
		GameWorld.archipelago.client.disconnect_from_ap()
		connectButton.text = "Connect"
		shouldDisconnect = false
		newGameButton.disabled = true

func onArchipelagoFailure(errorMessage) -> void:
	connectButton.text = "Connect"
	shouldDisconnect = false

func onArchipelagoConnected():
	connectButton.text = "Disconnect"
	shouldDisconnect = true
	newGameButton.disabled = false
	newGameButton.grab_focus()
