extends Node2D

@onready var anim_player =  $AnimationPlayer
const grass_overlay_text = preload("res://Assets/Grass/tall_grass.png")
var grass_overlay :TextureRect = null


func _ready():
	#get_tree().current_scene.find_children()
	pass
	
func _on_area_2d_body_entered(_body: Node2D):
	anim_player.play("Stepped")
