extends Node2D

var button_type = null

func _on_start_pressed() -> void:
	button_type= "start"
	$fadeTransition.show()
	$fadeTransition/fade_timer.start()
	$fadeTransition/AnimationPlayer.play("fade_in")
	
func _on_options_pressed() -> void:
	button_type= "options"
	$fadeTransition.show()
	$fadeTransition/fade_timer.start()
	$fadeTransition/AnimationPlayer.play("fade_in")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_fade_timer_timeout() -> void:
	if button_type == "start":
		get_tree().change_scene_to_file("res://awtg.tscn")
	elif button_type == "options":
		get_tree().change_scene_to_file("res://main menu/options.tscn")
