extends Node

signal request_state_change(new_state : int)
@onready var sm := get_parent()

func enter(params : Dictionary = {}) -> void:
	set_process(true)
	# show UI, reset variables, start timers, etc.
	print("Entered Tutorial")
	Globals.blocks_to_free = 3
	sm.diag_tutorial0.popup_centered()

func exit() -> void:
	set_process(false)
	# hide UI, stop timers, cleanup
	print("Exited Tutorial")

func _process(delta: float) -> void:
	if Globals.block_free >= Globals.blocks_to_free:
		print("✅ Threshold reached!")
		Globals.block_free = 0  # reset if needed
		emit_signal("request_state_change", get_parent().State.LevelOne)
	# Example: press accept to go to LevelOne
	#if Input.is_action_just_pressed("ui_accept"):
		## Tell the StateMachine to switch (we use parent's enum here)
		#emit_signal("request_state_change", get_parent().State.LevelOne)
