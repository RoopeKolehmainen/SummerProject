extends Node
class_name character 
@export var node :Node
var health 
var damage
@export var is_player : bool

func _ready():
	gamestart()

func gamestart():
	health = node.returnhealth()
	damage = node.returndamage()

func takedamage(damage : int):
	print()
	health -= damage
	print(health)
	if health < 1:
		get_tree().root.queue_free()
		if is_player == true:
			pass
			#TODO gameover systeemi
