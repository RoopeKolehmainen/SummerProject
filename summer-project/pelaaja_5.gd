extends CharacterBody2D

@export_category("Settings")
var TILE_SIZE = 16
@export var speed = 4
@export var sprint_speed = 10

enum State {WALK, RUN, IDLE}
enum Direction {UP, LEFT, RIGHT, DOWN}

var player_state = State.IDLE
var facing_direction = Direction.DOWN

var initial_position = Vector2()
var player_direction = Vector2.ZERO
var is_moving = false

var percent_to_next_tile = 0.0
var input_buffer = []
var input_buffer_readout = Vector2.ZERO

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var ray = $RayCast2D

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
			idle()
	
	if is_moving == false:
		process_player_input()
	
	# You can adjust speed here if needed
	speed = 8
	player_animations()
	print(is_moving)

func walk(delta):
	var desired_step: Vector2 = player_direction * TILE_SIZE / 2
	ray.target_position = desired_step
	ray.force_raycast_update()
	if not ray.is_colliding():
		percent_to_next_tile += speed * delta
		if percent_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE * player_direction)
			percent_to_next_tile = 0.0
			is_moving = false
		else:
			position = initial_position + (TILE_SIZE * player_direction * percent_to_next_tile)
	else:
		is_moving = false
		percent_to_next_tile = 0.0

func run(delta):
	var desired_step: Vector2 = player_direction * TILE_SIZE / 2
	ray.target_position = desired_step
	ray.force_raycast_update()
	if not ray.is_colliding():
		percent_to_next_tile += sprint_speed * delta
		if percent_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE * player_direction)
			percent_to_next_tile = 0.0
			is_moving = false
			player_state = State.IDLE
		else:
			position = initial_position + (TILE_SIZE * player_direction * percent_to_next_tile)
	else:
		is_moving = false
		percent_to_next_tile = 0.0

func idle():
	if player_direction != Vector2.ZERO:
		player_state = State.WALK

func player_animations():
	match player_state:
		State.WALK:
			anim_state.travel("Walk")
		State.RUN:
			anim_state.travel("Walk")
		State.IDLE:
			anim_state.travel("Idle")

func process_player_input():
	# Clear previous buffer if no new input
	# Buffer only stores recent key presses
	# Check for new key presses
	if Input.is_action_just_pressed("right"):
		input_buffer.append(Vector2.RIGHT)
	elif Input.is_action_just_pressed("left"):
		input_buffer.append(Vector2.LEFT)
	elif Input.is_action_just_pressed("up"):
		input_buffer.append(Vector2.UP)
	elif Input.is_action_just_pressed("down"):
		input_buffer.append(Vector2.DOWN)

	# Remove keys when released
	if Input.is_action_just_released("right"):
		input_buffer.erase(Vector2.RIGHT)
	elif Input.is_action_just_released("left"):
		input_buffer.erase(Vector2.LEFT)
	elif Input.is_action_just_released("up"):
		input_buffer.erase(Vector2.UP)
	elif Input.is_action_just_released("down"):
		input_buffer.erase(Vector2.DOWN)

	# Determine the last input from buffer
	if input_buffer.size() > 0:
		input_buffer_readout = input_buffer[-1]
	else:
		input_buffer_readout = Vector2.ZERO

	# If there's buffered input, set player_direction accordingly
	if input_buffer_readout != Vector2.ZERO:
		# Only change direction if not currently moving
		if not is_moving:
			player_direction = input_buffer_readout
			initial_position = position
			is_moving = true
			# Set animations parameters based on direction
			anim_tree.set("parameters/Idle/blend_position", player_direction)
			anim_tree.set("parameters/Walk/blend_position", player_direction)
			anim_tree.set("parameters/Run/blend_position", player_direction)
	else:
		# No input, set to idle if not moving
		if not is_moving:
			player_state = State.IDLE

	# Handle sprint input
	if Input.is_action_pressed("sprint") and player_direction != Vector2.ZERO:
		player_state = State.RUN
	else:
		player_state = State.WALK
