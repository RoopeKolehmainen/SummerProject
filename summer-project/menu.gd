extends Control

class_name Menu

signal button_focused(button :BaseButton)
signal button_pressed(button: BaseButton)

var index : int = 0

func _ready() -> void:
	
	for button in get_buttons():
		button.focus_exited.connect(_on_Button_focus_exited.bind(button))
		button.focus_entered.connect(_on_Button_focused.bind(button))
		button.pressed.connect(_on_Button_pressed.bind(button))

func get_buttons() -> Array:
	return get_children() 

func connect_to_buttons(target: Object, _name :String = name):
	var callable: Callable = Callable(target,"_on_" + _name + "_focused")
	button_focused.connect(callable)
	callable = Callable(target, "_on_" + _name + "_pressed")
	button_pressed.connect(callable)
 
func button_focus(n : int = index) -> void:
	var button : BaseButton = get_buttons()[n]
	button.grab_focus()

func _on_Button_pressed(button: BaseButton) -> void:
	emit_signal("button_pressed", button)

func _on_Button_focused(button :BaseButton) -> void:
	emit_signal("button_focused", button)
	
func _on_Button_focus_exited(button : BaseButton) -> void:
	await get_tree().process_frame
	if get_viewport().gui_get_focus_owner() in get_buttons():
		print("bring back")
		return
	
	button.grab_focus()
