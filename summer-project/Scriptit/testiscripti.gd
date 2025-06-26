extends Node


func _ready() -> void:
	
	pass

func _physics_process(_delta: float) -> void:
	var speed :int
	speed = jokufunktio(8)

func jokufunktio(x :int = 6) -> int:
	return x * 2

func jokufunktio2():
	return 1
