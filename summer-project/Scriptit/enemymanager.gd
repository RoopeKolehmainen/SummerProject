extends Node
class_name ID
var enemyID:int 
var enemydictionary = {}



func assign_enemy_ID(nodeName):
	enemydictionary.get_or_add({nodeName : enemyID})
	enemyID += 1
	print(enemydictionary)
	
	
