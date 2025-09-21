extends Node

signal request_state_change(new_state : int)
@onready var sm := get_parent()
@onready var parent := get_parent().get_parent()

func enter(_params : Dictionary = {}) -> void:
	set_process(true)
	print("Entered Tutorial")
	Globals.blocks_to_free = 1
	sm.set_diag("Click the dashed blocks to learn your first character.","ok")

func Tutorial():	
	for i in range(1):
		sm.jp_lesson.spawn_doubleBlock("a",1)
		await get_tree().create_timer(2.0).timeout

func exit() -> void:
	set_process(false)
	print("Exited Tutorial")

func _process(_delta: float) -> void:
	if Globals.block_free >= Globals.blocks_to_free:
		print("✅ Threshold reached!")
		Globals.block_free = 0  # reset if needed
		emit_signal("request_state_change", get_parent().State.LevelOne)
