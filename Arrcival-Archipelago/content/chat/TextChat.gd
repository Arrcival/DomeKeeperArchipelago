extends Control


var textBox: RichTextLabel

var i = 1

const MAX_LINE_COUNT = 7

const MAX_TIMER := 5

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
	currentTimer = 0
	timerReached = false
	textBox.modulate.a = 1
	$Tween.stop_all()
	if textBox.get_line_count() > MAX_LINE_COUNT:
		textBox.remove_line(0)
	textBox.newline()
	textBox.append_bbcode(text)
