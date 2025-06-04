extends Node2D


func _ready():
	print(Global.door_name)

#Code for door poistion on to player

	if Global.door_name != null:
		var door_node = find_child(Global.door_name)
		$Player.global_position = door_node.global_position
