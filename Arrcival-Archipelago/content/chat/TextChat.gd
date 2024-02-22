extends Control


var textBox: RichTextLabel

var i = 1

const MAX_LINE_COUNT = 7

const MAX_TIMER := 10

var currentTimer = MAX_TIMER

var timerReached = true

# Called when the node enters the scene tree for the first time.
func _ready():
	textBox = find_node("RichTextLabel")
	GameWorld.chat = self
	GameWorld.archipelago.client.connect("connect_status", self, "addText")
	GameWorld.archipelago.client.connect("could_not_connect", self, "addText")
	GameWorld.archipelago.client.connect("client_connected", self, "addText")
	GameWorld.archipelago.client.connect("connectedWithRoomInfo", self, "addText")
	GameWorld.archipelago.client.connect("logInformations", self, "addText")
	GameWorld.archipelago.connect("logInformations", self, "addText")
	
	addText("Press T to display again the text box at any time.")
	
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_T:
			resetTimer()

func resetTimer():
	currentTimer = 0
	timerReached = false
	textBox.modulate.a = 1
	$Tween.stop_all()
	

func _process(deltaTime: float):
	if not timerReached:
		currentTimer += deltaTime
		if currentTimer >= MAX_TIMER:
			timerReached = true
			$Tween.stop_all()
			$Tween.interpolate_property(
				textBox,
				'modulate:a',
				textBox.get_modulate().a,
				0.0,
				0.75,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			$Tween.start()


func addText(text):
	resetTimer()
	if textBox.get_line_count() > MAX_LINE_COUNT:
		textBox.remove_line(0)
	textBox.newline()
	textBox.append_bbcode(text)
