extends Node

signal request_state_change(new_state : int)
@onready var sm := get_parent()

func enter(params : Dictionary = {}) -> void:
	set_process(true)
	# show UI, reset variables, start timers, etc.
	print("Entered LevelOne")
	sm.diag_lvl1.popup_centered()

func exit() -> void:
	set_process(false)
	# hide UI, stop timers, cleanup
	print("Exited LevelOne")

func _process(delta: float) -> void:
	# Example: press accept to go to LevelOne
	if Input.is_action_just_pressed("ui_accept"):
		# Tell the StateMachine to switch (we use parent's enum here)
		emit_signal("request_state_change", get_parent().State.LevelTwo)
