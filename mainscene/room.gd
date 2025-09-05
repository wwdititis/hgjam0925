extends Node2D

@onready var paint: Button = $paint


func _on_btn_pc_pressed() -> void:
	pass # Replace with function body.


func _on_paint_pressed() -> void:
	get_tree().change_scene_to_packed(Globals.paint)
