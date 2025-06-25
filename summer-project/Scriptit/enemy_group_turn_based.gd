extends Node2D
var enemies: Array = []
var index : int = 0
var action_que: Array = []
var is_battling:bool = false
signal next_player
@onready var choice = $"../CanvasLayer/choice"

func _ready():
	enemies = get_children()
	for i in enemies.size():
		enemies[i].position = Vector2(0, i*32)
	show_choice()

func _process(_delta):
	if not choice.visible:
		if Input.is_action_just_pressed("up"):
			if index > 0:
				index -= 1
				switch_focus(index, index+1)
		if Input.is_action_just_pressed("down"):
			if index < enemies.size() -1:
				index += 1
				switch_focus(index, index -1)
		if Input.is_action_just_pressed("ui_accept"):
			action_que.push_back(index)
			emit_signal("next_player")
			
		if action_que.size() == enemies.size() and not is_battling:
			is_battling = true
			_action(action_que)
		

func _action(stack):
	for i in stack:
		enemies[i].take_damage(1)
		await get_tree().create_timer(1).timeout
	action_que.clear()
	is_battling = false
	show_choice()


func switch_focus(x,y):
	enemies[x].focus()
	enemies[y].unfocus()

func show_choice():
	choice.show()
	choice.find_child("Button").grab_focus()
	
func _reset_focus():
	for enemy in enemies:
		enemy.unfocus()
		
func start_choosing():
	_reset_focus()
	enemies[0].focus()

func _on_button_pressed() -> void:
	choice.hide()
	start_choosing()


#Kommentti
