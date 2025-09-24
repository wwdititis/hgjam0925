extends Node2D

@onready var hud: HUD = $"../HUD"
var scene_instance: Node = null
@onready var bed: Button = $bed/bed

func _on_bed_pressed() -> void:
	if bed.disabled:
		return
	else:
		if Globals.sleep_enabled:
			hud.set_dialog_window("Bed","Go to sleep?")
		else:
			hud.dialog_container.visible = true
			hud.dialog_panel.text = "I can't go to sleep before packing some things."

func _on_mini_paint_pressed() -> void:
	scene_instance = Globals.PAINT.instantiate()
	scene_instance.z_index = 1000
	hud.hide()
	add_child(scene_instance)

func _on_mini_lesson_pressed() -> void:
	hud.dialog_lesson()
