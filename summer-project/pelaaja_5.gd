
extends CharacterBody2D

@export_category("Settings")
var TILE_SIZE = 16
@export var speed = 4
@export var sprint_speed = 10

enum State { IDLE, WALK, RUN }
enum Direction { UP, LEFT, RIGHT, DOWN }

var player_state = State.IDLE
var facing_direction = Direction.DOWN

var initial_position = Vector2.ZERO
var player_direction = Vector2.ZERO
var is_moving = false
var percent_to_next_tile = 0.0
var direction_keys: Array = []

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var ray = $RayCast2D

func _ready():
	initial_position = position
	anim_tree.set("parameters/Idle/blend_position", Vector2.DOWN)

func _physics_process(delta):
	process_player_input()
	
	match player_state:
		State.WALK:
			walk(delta)
		State.RUN:
			run(delta)
		State.IDLE:
			idle()

	player_animations()
	direction_strength()

func process_player_input():
	if is_moving:
		return  # Don't process new input while moving

	var direction_map = {
		"left": Vector2(-1, 0),
		"right": Vector2(1, 0),
		"up": Vector2(0, -1),
		"down": Vector2(0, 1)
	}

	if direction_keys.size() > 0:
		var key = direction_keys.back()
		player_direction = direction_map.get(key, Vector2.ZERO)
	else:
		player_direction = Vector2.ZERO
		player_state = State.IDLE
		return

	if player_direction != Vector2.ZERO:
		initial_position = position
		is_moving = true
		percent_to_next_tile = 0.0

		# Update animation directions
		anim_tree.set("parameters/Idle/blend_position", player_direction)
		anim_tree.set("parameters/Walk/blend_position", player_direction)
		anim_tree.set("parameters/Run/blend_position", player_direction)

		# Choose state
		if Input.is_action_pressed("sprint"):
			player_state = State.RUN
		else:
			player_state = State.WALK

func walk(delta):
	var desired_step = player_direction * TILE_SIZE / 2
	ray.target_position = desired_step
	ray.force_raycast_update()

	if !ray.is_colliding():
		percent_to_next_tile += speed * delta

		if percent_to_next_tile >= 1.0:
			position = initial_position + TILE_SIZE * player_direction
			percent_to_next_tile = 0.0
			is_moving = false
			player_state = State.IDLE
		else:
			position = initial_position + TILE_SIZE * player_direction * percent_to_next_tile
	else:
		is_moving = false
		percent_to_next_tile = 0.0
		player_state = State.IDLE

func run(delta):
	var desired_step = player_direction * TILE_SIZE / 2
	ray.target_position = desired_step
	ray.force_raycast_update()

	if !ray.is_colliding():
		percent_to_next_tile += sprint_speed * delta

		if percent_to_next_tile >= 1.0:
			position = initial_position + TILE_SIZE * player_direction
			percent_to_next_tile = 0.0
			is_moving = false
			player_state = State.IDLE
		else:
			position = initial_position + TILE_SIZE * player_direction * percent_to_next_tile
	else:
		is_moving = false
		percent_to_next_tile = 0.0
		player_state = State.IDLE

func idle():
	# Nothing happens in idle except waiting for input
	pass

func player_animations():
	match player_state:
		State.WALK:
			anim_state.travel("Walk")
		State.RUN:
			anim_state.travel("Run")  # Using Run animation for run state
		State.IDLE:
			anim_state.travel("Idle")

func direction_strength():
	var directions = ["right", "left", "up", "down"]
	for dir in directions:
		if Input.is_action_just_pressed(dir):
			direction_keys.erase(dir)
			direction_keys.push_back(dir)
		elif Input.is_action_just_released(dir):
			direction_keys.erase(dir)
	if direction_keys.size() == 0:
		direction_keys.clear()
