extends Node
class_name enemycombatmanager
static var Instance : enemycombatmanager

func _ready():
	Instance = self

func start_combat():
	turnmanager.Instance.update_turn()
