extends CharacterBody2D

var TILE_SIZE = 16
var speed = 15


enum State{WALK, RUN, IDLE}
enum Direction{UP, LEFT, RIGHT, DOWN}

var player_state = State.IDLE
var facing_direction = Direction.DOWN

var initial_position = Vector2(0,0)
var player_direction = Vector2(0,0)
var is_moving = false

var percent_to_next_tile = 0.0

func _ready():
	initial_position = position
	
func _physics_process(delta):
	match player_state:
		State.WALK:
			walk(delta)
		State.RUN:
			pass
		State.IDLE:
			pass
	if is_moving == false:
		process_player_input()
	move_and_slide()
		
	
	
	
	
func walk(delta):
	percent_to_next_tile = speed * delta
	
	if percent_to_next_tile >= 1.0:
		position = initial_position + (TILE_SIZE*player_direction)
		percent_to_next_tile = 0.0
		is_moving = false

	else:
		position = initial_position + (TILE_SIZE * player_direction * percent_to_next_tile)
		player_state = State.IDLE
	
	
	
	
func process_player_input():
	if player_direction.x == 0:
		player_direction.y = int(Input.is_action_pressed("down"))-int(Input.is_action_pressed("up"))
	if player_direction.y == 0:
		player_direction.x = int(Input.is_action_pressed("right"))-int(Input.is_action_pressed("left"))
		
	
	player_state = State.WALK

func idle():
	if  player_direction != Vector2.ZERO:
		player_state = State.WALK
	
	
	
	
func run(delta):
	speed = 20
	
	pass
