extends Node

signal request_state_change(new_state : int)
@onready var sm := get_parent()
@onready var parent := get_parent().get_parent()

func enter(_params : Dictionary = {}) -> void:
	set_process(true)
	print("Entered LevelOne")
	Globals.blocks_to_free = 3
	sm.set_diag("Nice! You've learned that あ coresponds to A","ok")

func Lvl1():
	parent.tutorial = false
	parent.lvl1 = true
	parent.spawn_doubleBlock("a",1)
	await get_tree().create_timer(5.0).timeout

func exit() -> void:
	set_process(false)
	print("Exited LevelOne")

func _process(_delta: float) -> void:
	if Globals.block_free == 1:
		Globals.block_free +=1
		sm.set_diag2("Let's meet a new vowel...","ok")
		await sm.diag2.visibility_changed		
		for i in range(1):
			parent.spawn_doubleBlock("i",1)
			await get_tree().create_timer(2.0).timeout		
	if Globals.block_free >= Globals.blocks_to_free:		
		print("✅ Threshold reached!")
		Globals.block_free = 0  # reset if needed
		emit_signal("request_state_change", get_parent().State.LevelTwo)
