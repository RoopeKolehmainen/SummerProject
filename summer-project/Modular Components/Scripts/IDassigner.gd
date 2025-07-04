extends Node
class_name IDassigner

func _ready() -> void:
	await get_tree().process_frame
	enemymanager.Instance.assign_enemy_ID(self)
