extends Control

@onready var options :WindowDefault = $Options
@onready var options_menu :Menu = $Options/Options

func _ready() -> void:
	options_menu.button_focus(0)



func _on_options_button_focused(button: BaseButton) -> void:
	pass


func _on_options_button_pressed(button: BaseButton) -> void:
	print(button.text)
