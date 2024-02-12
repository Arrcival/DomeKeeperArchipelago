extends "res://stages/title/TitleStage.gd"

onready var archipelago_options_scene = load("res://mods-unpacked/Arrcival-Archipelago/content/options/ArchipelagoCategory.tscn")

var connectButton: Button
var newGameButton: Button

var shouldDisconnect = false

func build(data: Array):
	newGameButton = find_node("NewGameButton")
	connectButton = Button.new()
	connectButton.text = "Connect"
	
	
	
	
	connectButton.connect("pressed", self, "connect_archipelago", [])
	
	newGameButton.set_focus_neighbour(MARGIN_LEFT, connectButton.get_path())
	connectButton.set_focus_neighbour(MARGIN_RIGHT, newGameButton.get_path())
	newGameButton.grab_focus()
	
	add_child_first(find_node("MainMenuButtons"), connectButton)
	.build(data)
	
	var continueButton = find_node("ContinueButton")
	continueButton.disabled = true
	
	GameWorld.archipelago.client.connect("packetRoomInfo", self, "onArchipelagoConnected")
	#GameWorld.archipelago.client.connect("packetConnected", self, "onNewGameSuccess")
	GameWorld.archipelago.client.connect("could_not_connect", self, "onArchipelagoFailure")
	
	
	if GameWorld.archipelago.client.is_connected:
		onArchipelagoConnected()

func _on_OptionsButton_pressed()->void :
	Audio.sound("gui_title_options")
	var i = preload("res://systems/options/OptionsInputProcessor.gd").new()
	i.blockAllKeys = true
	var options_panel = preload("res://systems/options/OptionsPanel.tscn").instance()
	
	var archipelago_button = Button.new()
	archipelago_button.text = "Archipelago"
	archipelago_button.set_name("ArchipelagoCategoryButton")
	archipelago_button.connect("pressed", options_panel, "_on_CategoryButton_pressed", ["Archipelago"])
	options_panel.categories.push_back("Archipelago")
	options_panel.find_node("CategoriesList").add_child(archipelago_button)
	archipelago_button.owner = options_panel
	var archipelago_category = archipelago_options_scene.instance()
	archipelago_category.set_name("ArchipelagoCategory")
	options_panel.find_node("MarginContainer").add_child(archipelago_category)
	archipelago_category.owner = options_panel
	
	i.popup = options_panel
	i.stickReceiver = i.popup
	$Canvas.add_child(i.popup)
	i.popup.setFromOptions()
	i.integrate(self)
	i.connect("onStop", self, "optionsClosed", [i.popup])
	i.popup.connect("close", i, "desintegrate")
	find_node("Overlay").showOverlay()

func moveMenuIn(delay: = defaultDelay):
	if isMenuIn:
		return 
	
	isMenuIn = true
	$Tween.interpolate_property($Canvas / MainMenu, "rect_position:y", $Canvas / MainMenu.rect_position.y, mainMenuPos, moveDuration, Tween.TRANS_CUBIC, Tween.EASE_OUT, delay)
	$Tween.interpolate_property($Canvas / AdditionalMenu, "rect_position:y", $Canvas / AdditionalMenu.rect_position.y, additionalMenuPos, moveDuration, Tween.TRANS_CUBIC, Tween.EASE_OUT, delay + 0.2)
	$Tween.interpolate_property($Canvas / VersionContainer, "rect_position:y", $Canvas / VersionContainer.rect_position.y, versionContainerPos, moveDuration, Tween.TRANS_CUBIC, Tween.EASE_OUT, delay + moveDuration)
	if find_node("PrestigeMenu"):
		$Tween.interpolate_callback(find_node("PrestigeMenu"), delay + moveDuration, "mainMenuIn")
	
	
	
	find_node("ContinueButton").hide()
	$Tween.interpolate_callback(InputSystem, delay + 0.5 * moveDuration, "grabFocus", find_node("NewGameButton"))
	newGameButton.disabled = !GameWorld.archipelago.client.is_connected
	newGameButton.focus_neighbour_left = find_node("CreditsButton").get_path()
		
	$Tween.start()
	
#func _on_NewGameButton_pressed()->void :
#	Audio.sound("gui_title_newgame")
#	GameWorld.archipelago.client.connectToRoom(GameWorld.archipelago.slotName, GameWorld.archipelago.password)

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
	
