class_name player extends CharacterBody2D

@export var speed = 600



func _physics_process(delta: float):
	player_movement(delta)
	move_and_slide()

	
	
func player_movement(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed


func playerstartpos(startposition:Transform2D):
	transform = startposition
