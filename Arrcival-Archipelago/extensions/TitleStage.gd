extends "res://stages/title/TitleStage.gd"

var connectButton: Button
var newGameButton: Button

func build(data: Array):

	newGameButton = find_child("NewGameButton")
	newGameButton.disabled = true
	connectButton = Button.new()
	connectButton.name = "ConnectButton"
	connectButton.text = "Connect"
	
	connectButton.pressed.connect(self.connect_archipelago)

	var additionalButtons: Node = find_child("AdditionalButtons")
	var currentFirstButton: Node = additionalButtons.get_child(0)
	
	add_child_first(additionalButtons, connectButton)


	currentFirstButton.set_focus_neighbor(Side.SIDE_TOP, NodePath(connectButton.get_path()))
	connectButton.set_focus_neighbor(Side.SIDE_BOTTOM, NodePath(currentFirstButton.get_path()))
	connectButton.connect("focus_entered", on_additional_menu_button_entered.bind(connectButton))

	var continueButton = find_child("ContinueButton")
	continueButton.disabled = true
	continueButton.visible = false
	find_child("SplitscreenButton").disabled = true
	find_child("HostMultiplayerButton").disabled = true
	find_child("JoinMultiplayerButton").disabled = true

	#var prestigeButton = find_child("ToggleBoardButton")
	#connectButton.set_focus_neighbor(Side.SIDE_TOP, NodePath(prestigeButton.get_path()))
	
	GameWorld.archipelago.slot_data_have_been_retrieved.connect(self.onArchipelagoConnected)
	GameWorld.archipelago.client_disconnected.connect(self.onArchipelagoFailure)

	# so hovering prestige from connect goes back to connect when pressing down
	if GameWorld.isUnlocked(CONST.MODE_PRESTIGE):
		var prestigeNode = find_child("PrestigeMenu")
		#moddingButton.disconnect("focus_entered", Callable(prestigeNode, "on_mainmenu_button_focussed").bind(moddingButton))
		connectButton.connect("focus_entered", Callable(prestigeNode, "on_mainmenu_button_focussed").bind(connectButton))
	

	# in case of coming back from new game to the main menu
	if GameWorld.archipelago.is_client_connected():
		onArchipelagoConnected()
		
	InputSystem.grabFocus(connectButton)
	Style.init($Canvas / AdditionalMenu)
	super.build(data)

func beforeStart() -> void:
	super.beforeStart()
	InputSystem.grabFocus(connectButton)


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
	if GameWorld.archipelago.is_connection_disconnected():
		GameWorld.archipelago.connect_new_session()
		GameWorld.archipelago.logInformations.emit("Connecting to " + GameWorld.archipelago.get_server_name())
	else:
		GameWorld.archipelago.disconnect_client_and_reset()
		connectButton.text = "Connect"
		newGameButton.disabled = true

func onArchipelagoFailure() -> void:
	connectButton.text = "Connect"
	newGameButton.disabled = true

func onArchipelagoConnected():
	connectButton.text = "Disconnect"
	newGameButton.disabled = false
	InputSystem.grabFocus(newGameButton)
