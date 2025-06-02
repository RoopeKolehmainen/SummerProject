extends Area2D


@export var SceneName:String
@export var is_door_exit:bool


func ready():
	pass
	
	
func _input(event):
	if event.is_action_pressed("interact"):
		print (get_overlapping_bodies().size())
		scenevaihto()

func scenevaihto():
	var paikka:Transform2D
	paikka.x = transform.x
	paikka.y = transform.y
	if is_door_exit == false:
		SceneManager.playerpos(paikka)
	if Input.is_action_pressed("interact") and has_overlapping_bodies():
		SceneManager.change_scene(SceneName)

	
