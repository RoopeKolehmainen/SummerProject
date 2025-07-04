extends Node
class_name enemymanager
static var Instance : enemymanager
var enemydictionary : Array = []

func _ready():
	Instance = self


func assign_enemy_ID(node : Node):
	enemydictionary.insert(enemydictionary.size(), node)

func remove_enemy(node : Node):
	enemydictionary.erase(node)
