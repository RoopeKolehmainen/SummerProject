extends Area2D

class_name Portal

@export_file("*.tscn") var target_scene

#Event function that runs the scene change function or displays an error if there is no scene in the current hitbox
func _input(event):
	if event.is_action_pressed("interact") and has_overlapping_bodies():
		if !target_scene:
			print("no scene here")
			return
		if get_overlapping_bodies().size() > 0:
			scenevaihto()

#The main function for changing the scene, takes the allocated scene from target_scene and also writes the doors name in the global autoload script for other scripts to use
func scenevaihto():
	var ERR = get_tree().change_scene_to_file(target_scene)
	if ERR != OK:
		print("somethign went wrong")
	Global.door_name = name
		
