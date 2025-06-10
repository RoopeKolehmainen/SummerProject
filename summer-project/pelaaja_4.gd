extends CharacterBody2D

@export_category("Settings")
var TILE_SIZE = 16
@export var speed = 6
@export var sprint_speed = 10

enum State { WALK, RUN, IDLE }
enum Direction { UP, LEFT, RIGHT, DOWN }

var player_state = State.IDLE
var facing_direction = Direction.DOWN

var initial_position = Vector2.ZERO
var player_direction = Vector2.ZERO
var is_moving = false

var percent_to_next_tile = 0.0

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

func _ready():
	initial_position = position
	anim_tree.set("parameters/Idle/blend_position", Vector2.DOWN)

func _physics_process(delta):
	match player_state:
		State.WALK:
			walk(delta)
		State.RUN:
			run(delta)
		State.IDLE:
			if not is_moving:
				check_movement_keys()

	player_animations()

func check_movement_keys():
	var direction_map = {
		"left": Vector2(-1, 0),
		"right": Vector2(1, 0),
		"up": Vector2(0, -1),
		"down": Vector2(0, 1)
	}

	for dir in direction_map.keys():
		if Input.is_action_pressed(dir):
			player_direction = direction_map[dir]
			initial_position = position
			is_moving = true
			percent_to_next_tile = 0.0

			anim_tree.set("parameters/Idle/blend_position", player_direction)
			anim_tree.set("parameters/Walk/blend_position", player_direction)
			anim_tree.set("parameters/Run/blend_position", player_direction)

			if Input.is_action_pressed("sprint"):
				player_state = State.RUN
			else:
				player_state = State.WALK
			break

func walk(delta):
	percent_to_next_tile += speed * delta
	if percent_to_next_tile >= 1.0:
		position = initial_position + TILE_SIZE * player_direction
		is_moving = false
		player_state = State.IDLE
	else:
		position = initial_position + TILE_SIZE * player_direction * percent_to_next_tile

func run(delta):
	percent_to_next_tile += sprint_speed * delta
	if percent_to_next_tile >= 1.0:
		position = initial_position + TILE_SIZE * player_direction
		is_moving = false
		player_state = State.IDLE
	else:
		position = initial_position + TILE_SIZE * player_direction * percent_to_next_tile

func player_animations():
	match player_state:
		State.WALK:
			anim_state.travel("Walk")
		State.RUN:
			anim_state.travel("Run")
		State.IDLE:
			anim_state.travel("Idle")
