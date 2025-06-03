class_name Scenemanager extends Node
var playerposition:Vector2

func change_scene(sceneswitch:String) -> void:
	get_tree().change_scene_to_file("res://Scenet/"+ sceneswitch +".tscn")
	
	
	
