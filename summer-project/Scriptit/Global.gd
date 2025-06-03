extends Node

var path:String = "res://Scenet/"
var file_type:String = ".tscn"
var player_position:Vector2

func change_scene(sceneswitch:String) -> void:
	get_tree().change_scene_to_file(path + sceneswitch + file_type)

	
	
