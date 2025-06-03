extends Area2D

class_name Portal

@export var SceneName:String
@export var is_door_exit:bool

func ready():
	pass
	
	
func _input(event):
	if event.is_action_pressed("interact"):
		print (get_overlapping_bodies().size())
		scenevaihto()

func scenevaihto():
	if Input.is_action_just_pressed("interact") and has_overlapping_bodies():
		SceneManager.change_scene(SceneName)

	
