class_name Scenemanager extends Node
var playerposition:Transform2D

func change_scene(sceneswitch:String) -> void:
	get_tree().change_scene_to_file("res://Scenet/"+ sceneswitch +".tscn")
	
	
	
func playerpos(position:Transform2D):
	playerposition = position
	print_debug(position)
