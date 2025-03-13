extends "res://content/pause/PauseMenu.gd"

var connectButton: Button

func _ready():
	super._ready()
	
	GameWorld.archipelago.client_disconnected.connect(self.onArchipelagoDisconnect)
	GameWorld.archipelago.client_connected.connect(self.onArchipelagoConnected)
	
	connectButton = Button.new()
	connectButton.name = "ButtonConnect"
	connectButton.text = "Reconnect"
	connectButton.disabled = false
	connectButton.pressed.connect(self.connect_archipelago)
	
	var container = $MenuPanel/VBoxContainer
	
	container.add_child(connectButton)
	container.move_child(connectButton, 2)
	
	if GameWorld.archipelago.is_client_connected():
		onArchipelagoConnected()
		
	Style.init(connectButton)

func onArchipelagoConnected():
	connectButton.text = "Connected"
	connectButton.disabled = true

func onArchipelagoDisconnect():
	connectButton.text = "Reconnect"
	connectButton.disabled = false

func connect_archipelago():
	connectButton.text = "Connecting..."
	if GameWorld.archipelago.connection == GameWorld.archipelago.CONNECTION_STATUS.DISCONNECTED:
		GameWorld.archipelago.connectClient()
	else:
		GameWorld.archipelago.disconnect_client()
		connectButton.text = "Reconnect"
	
