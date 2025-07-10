extends Button


func _on_pressed():
	if turnmanager.Instance.get_player_state() == false:
		return
	attackmanager.Instance.useattack(self)
	print("tosi")
	
