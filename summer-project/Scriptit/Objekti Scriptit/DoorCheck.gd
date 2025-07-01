extends Node2D

#Prints the currently saved door name from autoload as a check
func _ready():
	print(Global.door_name)

#moves the player on top of the door collider on scene change
	if Global.door_name != null:
		var door_node = find_child(Global.door_name)
		$Player.global_position = door_node.global_position
