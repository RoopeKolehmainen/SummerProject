extends CharacterBody2D

@export_category("Settings")
var TILE_SIZE = 16
@export var speed = 4
@export var sprint_speed = 10

enum State{WALK, RUN, IDLE}
enum Direction{UP, LEFT, RIGHT, DOWN}

var player_state = State.IDLE
var facing_direction = Direction.DOWN

var initial_position = Vector2(0,0)
var player_direction = Vector2(0,0)
var is_moving = false

var percent_to_next_tile = 0.0
var direction_keys :Array = []



@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var ray = $RayCast2D

func _ready():
	initial_position = position
	anim_tree.set("parameters/Idle/blend_position", Vector2.DOWN)

func _process(delta):
	movement_inputs()
	
func _physics_process(delta):
	#calls all functions in the project
	#movement_inputs()
	match player_state:
		State.WALK:
			walk(delta)
		State.RUN:
			run(delta)
		State.IDLE:
			idle()
	if is_moving == false:
		process_player_input()
	speed = 8
	player_animations()
	
	
func walk(delta):

	var desired_step:Vector2 = player_direction * TILE_SIZE/2
	ray.target_position = desired_step
	ray.force_raycast_update()
	if !ray.is_colliding():
		percent_to_next_tile += speed*delta
		if percent_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE*player_direction)
			percent_to_next_tile = 0.0
			is_moving = false

		else:
			position = initial_position + (TILE_SIZE * player_direction * percent_to_next_tile)
	else:
		is_moving = false
		percent_to_next_tile = 0.0
	
	
func process_player_input():
	#Handles player input and sets animations

	# Get input direction from directional key input stack
	if direction_keys.size() == 0:
		player_direction = Vector2.ZERO

	else:
		var key = direction_keys.back()
		if Input.is_action_pressed(key):
			if key == "right":
				player_direction.x = 1
				player_direction.y = 0
			elif key == "left":
				player_direction.x = -1
				player_direction.y = 0
			elif key == "down":
				player_direction.x = 0
				player_direction.y = 1
			elif key == "up":
				player_direction.x = 0
				player_direction.y = -1
			else:
				player_direction = Vector2.ZERO

	if player_direction != Vector2.ZERO:
		initial_position = position
		is_moving = true
		anim_tree.set("parameters/Idle/blend_position", player_direction)
		anim_tree.set("parameters/Walk/blend_position",player_direction)
		anim_tree.set("parameters/Run/blend_position", player_direction)
	else:
		player_state = State.IDLE
	if Input.is_action_pressed("sprint") and player_direction != Vector2.ZERO:
		player_state = State.RUN


func idle():
	#only here to set state to idle so animations play correctly
	if  player_direction != Vector2.ZERO:
		player_state = State.WALK

func run(delta):
	#Player movement script, makes the player move by tiles always, sets idle if not moving
	var desired_step:Vector2 = player_direction * TILE_SIZE/2
	ray.target_position = desired_step
	ray.force_raycast_update()
	if !ray.is_colliding():
		percent_to_next_tile += sprint_speed*delta
		if percent_to_next_tile >= 0.99:
			position = initial_position + (TILE_SIZE*player_direction)
			percent_to_next_tile = 0.0
			is_moving = false
			player_state = State.IDLE

		else:
			position = initial_position + (TILE_SIZE * player_direction * percent_to_next_tile)
	else:
		is_moving = false
		percent_to_next_tile = 0.0
		return

func player_animations():
	#Handles player animations with the help of states
	match player_state:
		State.WALK:
			anim_state.travel("Walk")
		State.RUN:
			anim_state.travel("Run")
		State.IDLE:
			anim_state.travel("Idle")

func movement_inputs():
		# Store direction keys in a "stack", ordered by when they're pressed
	if Input.is_action_just_pressed("right"):
		direction_keys.push_back("right")
	elif Input.is_action_just_released("right"):
		direction_keys.erase("right")
	if Input.is_action_just_pressed("left"):
		direction_keys.push_back("left")
	elif Input.is_action_just_released("left"):
		direction_keys.erase("left")
	if Input.is_action_just_pressed("down"):
		direction_keys.push_back("down")
	elif Input.is_action_just_released("down"):
		direction_keys.erase("down")
	if Input.is_action_just_pressed("up"):
		direction_keys.push_back("up")
	elif Input.is_action_just_released("up"):
		direction_keys.erase("up")
	if !Input.is_action_pressed("right") and !Input.is_action_pressed("left") and !Input.is_action_pressed("down") and !Input.is_action_pressed("up"):
		direction_keys.clear()
