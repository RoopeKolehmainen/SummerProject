extends Node
class_name attackmanager
static var Instance : attackmanager

func _ready():
	Instance = self

func useattack(target : Node):
	turnmanager.Instance.update_turn()
	#TODO attacking logic
	target.takedamage(5)
