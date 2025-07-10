extends Node
class_name turnmanager
var is_player_turn : bool = true
static var Instance : turnmanager

func _ready():
	Instance = self
	
func update_turn():
	if is_player_turn == false:
		is_player_turn = true
		return
	if is_player_turn == true:
		is_player_turn = false
		enemycombatmanager.Instance.start_combat()

func get_player_state() -> bool:
	return is_player_turn
