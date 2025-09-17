extends Node

#signal request_state_change(new_state : int)
@onready var sm := get_parent()

func enter(_params : Dictionary = {}) -> void:
	set_process(true)
	print("Entered LevelFour")
	Globals.blocks_to_free = 4
	await get_tree().create_timer(2.0).timeout
	sm.Lvl4()

func exit() -> void:
	set_process(false)
	print("Exited LevelFour")

func _process(_delta: float) -> void:
	if Globals.block_free >= Globals.blocks_to_free:
		print("✅ Threshold reached!")
		Globals.block_free = 0  # reset if needed
		#emit_signal("request_state_change", get_parent().State.LevelFive)
