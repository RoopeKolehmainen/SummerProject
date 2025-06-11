extends CharacterBody2D

@export_category("Settings")
var TILE_SIZE = 16
@export var speed = 64        # pixels per second walking speed
@export var sprint_speed = 160  # pixels per second sprinting speed

enum State {WALK, RUN, IDLE}
enum Direction {UP, LEFT, RIGHT, DOWN}

var player_state = State.IDLE
var facing_direction = Direction.DOWN

var initial_position = Vector2.ZERO
var player_direction = Vector2.ZERO
var is_moving = false

var percent_to_next_tile = 0.0
var direction_keys : Array = []

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var ray = $RayCast2D

func _ready():
	initial_position = position
	anim_tree.set("parameters/Idle/blend_position", Vector2.DOWN)

func _physics_process(delta):
	update_direction_keys()
	if not is_moving:
		process_player_input()
	match player_state:
		State.WALK:
			move_player(delta, speed)
		State.RUN:
			move_player(delta, sprint_speed)
		State.IDLE:
			idle()
	player_animations()

func move_player(delta, current_speed):
	var move_distance = current_speed * delta
	var total_distance = TILE_SIZE
	var desired_step = player_direction * TILE_SIZE
	ray.target_position = desired_step
	ray.force_raycast_update()
	
	if not ray.is_colliding():
		percent_to_next_tile += move_distance / total_distance
		if percent_to_next_tile >= 1.0:
			position = initial_position + desired_step
			percent_to_next_tile = 0.0
			is_moving = false
		else:
			position = initial_position + desired_step * percent_to_next_tile
	else:
		is_moving = false
		percent_to_next_tile = 0.0

func process_player_input():
	if player_direction != Vector2.ZERO:
		if not is_moving:
			initial_position = position
			percent_to_next_tile = 0.0
			is_moving = true
			anim_tree.set("parameters/Idle/blend_position", player_direction)
			anim_tree.set("parameters/Walk/blend_position", player_direction)
			anim_tree.set("parameters/Run/blend_position", player_direction)
		if Input.is_action_pressed("sprint"):
			player_state = State.RUN
		else:
			player_state = State.WALK
	else:
		player_state = State.IDLE
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

func update_direction_keys():
	var directions = {
		"right": Vector2.RIGHT,
		"left": Vector2.LEFT,
		"up": Vector2.UP,
		"down": Vector2.DOWN
	}

	for dir in directions.keys():
		if Input.is_action_just_pressed(dir):
			direction_keys.erase(dir)
			direction_keys.push_back(dir)

	for dir in direction_keys.duplicate():
		if not Input.is_action_pressed(dir):
			direction_keys.erase(dir)

	if direction_keys.size() > 0:
		var last_dir = direction_keys[direction_keys.size() - 1]
		player_direction = directions[last_dir]
	else:
		player_direction = Vector2.ZERO
