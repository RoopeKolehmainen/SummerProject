extends Button
@onready var child = get_node("Enemy")
func _on_pressed():
	print(child.name)
	if turnmanager.Instance.get_player_state() == false:
		return
	attackmanager.Instance.useattack(child)
	print("tosi")
	
