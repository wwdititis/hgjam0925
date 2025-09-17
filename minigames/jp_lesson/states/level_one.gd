extends Node

signal request_state_change(new_state : int)
@onready var sm := get_parent()
@onready var parent := get_parent().get_parent()

func enter(_params : Dictionary = {}) -> void:
	set_process(true)
	print("Entered LevelOne")
	Globals.blocks_to_free = 5
	sm.diag_tutorial1.popup_centered()

func Lvl1():
	parent.tutorial = false
	parent.lvl1 = true
	parent.spawn_doubleBlock("a",2)
	await get_tree().create_timer(5.0).timeout
	parent.spawn_doubleBlock("i",3)
	await get_tree().create_timer(5.0).timeout

func exit() -> void:
	set_process(false)
	print("Exited LevelOne")

func _process(_delta: float) -> void:
	if Globals.block_free >= Globals.blocks_to_free:
		print("✅ Threshold reached!")
		Globals.block_free = 0  # reset if needed
		emit_signal("request_state_change", get_parent().State.LevelTwo)
