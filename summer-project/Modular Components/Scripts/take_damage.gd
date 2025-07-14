extends Node
@export var health: int


func take_damage(damage : int):
	health -= damage
	#update UI
	if health < 1:
		enemymanager.Instance.remove_enemy(self)
		queue_free()
