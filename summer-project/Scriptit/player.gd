extends CharacterBody2D

class_name Player

@export_category("Player Settings")
@export var speed = 600
@export var TILE_SIZE_pixels = 16

var player_direction = Vector2.ZERO
var is_moving = false
var percent_to_next_tile = 0.0





func _physics_process(delta: float):
	player_movement(delta)
	move_and_slide()

	
	
func player_movement(_delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
