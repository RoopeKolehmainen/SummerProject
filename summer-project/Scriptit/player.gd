extends CharacterBody2D

class_name Player

@export var speed = 600
var location:Vector2

func _process(delta: float) -> void:
	location = Vector2(global_position.x, global_position.y * -1)
	MainGlobal.player_position = location
	print(MainGlobal.player_position)

func _ready() -> void:
	global_transform.origin = MainGlobal.player_position

func _physics_process(delta: float):
	player_movement(delta)
	move_and_slide()

	
	
func player_movement(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
