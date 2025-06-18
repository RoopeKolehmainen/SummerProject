extends Node2D
var enemies: Array = []

func _ready():
	enemies = get_children()
	for i in enemies.size():
		enemies[i].position = Vector2(0, i*32)


func _on_enemy_group_next_player() -> void:
	pass # Replace with function body.


func switch_focus(x,y):
	players[x].focus()
	players[y].unfocus()
