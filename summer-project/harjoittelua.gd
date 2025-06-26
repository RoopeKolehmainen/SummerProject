extends Node
enum State {hitting, blocking}
signal damage
var hitti = 10
@onready var button = $Button

func _ready():
	var button = Button.new()
	button.text = "Fight"
	button.pressed.connect(_button_pressed)
	button.position = Vector2(140, 80)
	add_child(button)

func _button_pressed():
	emit_signal("damage")
	print("signal emited")
