extends Node
class_name enemymanager
var enemyID:int 
var enemydictionary = {}
static var Instance : enemymanager


func _ready():
	Instance = self
	
func assign_enemy_ID(node : Node):
	enemydictionary.get_or_add({node : enemyID})
	enemyID += 1
	print(enemydictionary)
	
	
