extends Node
class_name enemymanager
var enemyID: int = 0
var enemydictionary = {}
static var Instance : enemymanager

func _ready():
	Instance = self

func assign_enemy_ID(node : Node):
	enemydictionary.get_or_add(enemyID , node)
	enemyID += 1


func remove_enemy(enemyID):
	enemydictionary.erase(enemyID)
