extends CharacterBody2D

class_name Player



@export_category("Player Settings")
@export var speed = 4
@export var TILE_SIZE = 16

enum PlayerState { IDLE, TURNING, WALKING }
enum FacingDirection { LEFT, RIGHT, UP, DOWN }

var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN

var initial_position = Vector2(0,0)
var player_direction = Vector2(0,0)
var is_moving = false
var percent_to_next_tile = 0.0
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")


func _ready():
	anim_tree.active = true

func _physics_process(delta):
	if player_state == PlayerState.TURNING:
		return

	elif is_moving == false:
		process_player_input()

	elif  player_direction != Vector2.ZERO:
		move(delta)
		anim_state.travel("Walk")

	else:
		anim_state.travel("Idle")
		is_moving = false

func process_player_input():
	if player_direction.y == 0:
		player_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))

	if player_direction.x == 0:
		player_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))

	if player_direction != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", player_direction)
		anim_tree.set("parameters/Walk/blend_position",player_direction)
		anim_tree.set("parameters/Turn/blend_position",player_direction)

		if need_to_turn():
			player_state = PlayerState.TURNING
			anim_state.travel("Turn")

		else:
			initial_position = position
			is_moving = true

	else:
		anim_state.travel("Idle")

func move(delta):
	percent_to_next_tile += speed * delta

	if percent_to_next_tile >= 0.99:
		position = initial_position + (TILE_SIZE*player_direction)	
		percent_to_next_tile = 0.0
		is_moving = false

	else:
		position = initial_position + (TILE_SIZE * player_direction * percent_to_next_tile)

func need_to_turn():
	var new_facing_direction = facing_direction

	if player_direction.x < 0:
		new_facing_direction = FacingDirection.LEFT

	elif player_direction.x > 0:
		new_facing_direction = FacingDirection.RIGHT

	elif player_direction.y < 0:
		new_facing_direction = FacingDirection.UP

	elif player_direction.y > 0:
		new_facing_direction = FacingDirection.DOWN
	
	if facing_direction != new_facing_direction:
		facing_direction = new_facing_direction
		return true

	return false

func finished_turning():
	player_state = PlayerState.IDLE
	
func player_sprint():
	pass
