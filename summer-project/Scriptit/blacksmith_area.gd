extends Area2D



func ready():
	pass
	
	
func _input(event):
	if event.is_action_pressed("interact"):
		print (get_overlapping_bodies().size())
		scenevaihto()

func scenevaihto():
	if Input.is_action_pressed("interact") and has_overlapping_bodies():
		get_tree().change_scene_to_file("res://TESTISCENE2.tscn")
