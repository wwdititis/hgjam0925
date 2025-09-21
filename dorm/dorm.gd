extends Node2D

@onready var hud: HUD = $"../HUD"
var scene_instance: Node = null

func _on_bed_pressed() -> void:
	hud.set_dialog_window("Bed","Go to sleep?")

func _on_mini_paint_pressed() -> void:
	scene_instance = Globals.PAINT.instantiate()
	scene_instance.z_index = 1000
	hud.hide()
	add_child(scene_instance)


func _on_mini_lesson_pressed() -> void:
	add_child(Globals.LESSON.instantiate())
