extends Area2D

class_name Portal

@export var SceneName:String


func ready():
	pass
	
	
func _input(event):
	if event.is_action_pressed("interact"):
		scenevaihto()

func scenevaihto():
	if Input.is_action_just_pressed("interact") and has_overlapping_bodies():
		MainGlobal.change_scene(SceneName)

	
