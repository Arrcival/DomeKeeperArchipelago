extends Control


var textBox: RichTextLabel

var i = 1

const MAX_LINE_COUNT = 7

const MAX_TIMER := 10

var currentTimer = MAX_TIMER

var timerReached = true

var textArray: Array[String] = []

# port from godot v3
func find_node(value: String) -> Node:
	return find_children(value)[0]

# Called when the node enters the scene tree for the first time.
func _ready():	
	textBox = find_node("RichTextLabel")
	textBox.set_use_bbcode(true)
	
	GameWorld.chat = self
	GameWorld.archipelago.client.connect_status.connect(self.addText)
	GameWorld.archipelago.client.client_connected.connect(self.addText)
	GameWorld.archipelago.client.could_not_connect.connect(self.addText)
	GameWorld.archipelago.client.connectedWithRoomInfo.connect(self.addText)
	GameWorld.archipelago.client.logInformations.connect(self.addText)
	
	addText("Press T to display again the text box at any time.")
	
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			resetTimer()

func resetTimer():
	currentTimer = 0
	timerReached = false
	self.modulate.a = 1
	$Tween.stop_all()

func _process(deltaTime: float):
	if not timerReached:
		currentTimer += deltaTime
		if currentTimer >= MAX_TIMER:
			timerReached = true
			$Tween.stop(self)
			$Tween.interpolate_property(
				self,
				'modulate:a',
				textBox.get_modulate().a,
				0.0,
				0.75,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			$Tween.start()

func addText(textToAdd: String):
	resetTimer()
	if textArray.size() > MAX_LINE_COUNT:
		textArray.pop_at(0)
	textArray.append(textToAdd)
	textBox.clear()
	for text in textArray:
		textBox.append_text(text)
		textBox.newline()

