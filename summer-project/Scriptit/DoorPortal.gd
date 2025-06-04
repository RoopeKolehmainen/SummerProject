extends Area2D

class_name Portal

@export_file("*.tscn") var target_scene
	
	
func _input(event):
	if event.is_action_pressed("interact"):
		if !target_scene:
			print("no scene here")
			return
		if get_overlapping_bodies().size() > 0:
			scenevaihto()

func scenevaihto():
	var ERR = get_tree().change_scene_to_file(target_scene)
	if ERR != OK:
		print("somethign went wrong")
	Global.door_name = name
		
