extends CharacterBody2D
@onready var _focus = $Focus
@onready var progressbar = $ProgressBar
@onready var anim_player = $AnimationPlayer

@export var maxHP:float = 7

var health:float = 7:
	set(value):
		health = value
		_update_progress_bar()
		_play_animation()
		
func  _update_progress_bar():
	progressbar.value = (health/maxHP) * 100
	
func _play_animation():
	anim_player.play("hurt")
	
func focus():
	_focus.show()
	
	
func unfocus():
	_focus.hide()

func take_damage(value):
	health -= value
