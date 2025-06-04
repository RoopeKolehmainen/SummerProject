extends CharacterBody2D

class_name Player



@export_category("Player Settings")
@export var speed = 4.0
@export var TILE_SIZE = 16

var initial_position = Vector2(0,0)
var player_direction = Vector2(0,0)
var is_moving = false
var percent_to_next_tile = 0.0





func _physics_process(delta):
	if is_moving == false:
		process_player_input()
	elif  player_direction != Vector2.ZERO:
		move(delta)
	else:
		is_moving = false


func process_player_input():
	if player_direction.y == 0:
		player_direction.x = int(Input.get_action_strength("right")) - int(Input.get_action_strength("left"))
		
	
	if player_direction.x == 0:
		player_direction.y = int(Input.get_action_strength("down")) - int(Input.get_action_strength("up"))
	
	
	if player_direction != Vector2.ZERO:
		initial_position = position
		is_moving = true



func move(delta):
	percent_to_next_tile += speed * delta
	if percent_to_next_tile >= 0.99:
		position = initial_position + (TILE_SIZE*player_direction)
		percent_to_next_tile = 0.0
		is_moving = false
	else:
		position = initial_position + (TILE_SIZE * player_direction * percent_to_next_tile)
