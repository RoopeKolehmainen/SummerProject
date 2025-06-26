extends Node
var health = 10

func _ready():
	pass
	


func _on_node_damage() -> void:
	take_damage()


func take_damage():
	health -= 1
	print(health)
	
