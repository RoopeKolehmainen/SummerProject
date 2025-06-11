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

func _physics_process(delta):
	#calls all functions in the project
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
	print(is_moving)
	
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
	if player_direction.y == 0:
		player_direction.x = int(Input.get_action_strength("right")) - int(Input.get_action_strength("left"))

	if player_direction.x == 0:
		player_direction.y = int(Input.get_action_strength("down")) - int(Input.get_action_strength("up"))
		
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
		if percent_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE*player_direction)
			percent_to_next_tile = 0.0
			is_moving = false
			player_state = State.IDLE

		else:
			position = initial_position + (TILE_SIZE * player_direction * percent_to_next_tile)
	else:
		is_moving = false
		percent_to_next_tile = 0.0

func player_animations():
	#Handles player animations with the help of states
	match player_state:
		State.WALK:
			anim_state.travel("Walk")
		State.RUN:
			anim_state.travel("Walk")
		State.IDLE:
			anim_state.travel("Idle")

func direction_stregnth():
	var directions = ["right", "left", "up", "down"]
	for dir in directions:
		if Input.is_action_just_pressed(dir):
			direction_keys.push_back(dir)
		elif Input.is_action_pressed(dir):
			direction_keys.erase(dir)
		if direction_keys.size() == 0:
			direction_keys.clear()

func movement_inputs():
		# Store direction keys in a "stack", ordered by when they're pressed
	if Input.is_action_just_pressed("ui_right"):
		direction_keys.push_back("ui_right")
	elif Input.is_action_just_released("ui_right"):
		direction_keys.erase("ui_right")
	if Input.is_action_just_pressed("ui_left"):
		direction_keys.push_back("ui_left")
	elif Input.is_action_just_released("ui_left"):
		direction_keys.erase("ui_left")
	if Input.is_action_just_pressed("ui_down"):
		direction_keys.push_back("ui_down")
	elif Input.is_action_just_released("ui_down"):
		direction_keys.erase("ui_down")
	if Input.is_action_just_pressed("ui_up"):
		direction_keys.push_back("ui_up")
	elif Input.is_action_just_released("ui_up"):
		direction_keys.erase("ui_up")
	if !Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_up"):
		direction_keys.clear()
