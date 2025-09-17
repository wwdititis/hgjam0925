extends Node

@onready var alert: ColorRect = $"../../alert"

signal request_state_change(new_state : int)
@onready var sm := get_parent()
@onready var parent := get_parent().get_parent()

func enter(_params : Dictionary = {}) -> void:
	set_process(true)
	print("Entered LevelTwo")
	Globals.blocks_to_free = 7
	sm.diag_tutorial2.popup_centered()

func Lvl2():
	parent.lvl1 = false
	parent.lvl2 = true
	parent.spawn_tripleBlock("a",2)
	await get_tree().create_timer(7.0).timeout
	parent.spawn_tripleBlock("i",2)
	await get_tree().create_timer(7.0).timeout
	
func exit() -> void:
	set_process(false)
	print("Exited LevelTwo")

func _process(_delta: float) -> void:
	if Globals.block_free == 4:
		Globals.block_free +=1
		alert.visible = true
		sm.message_alert("Time to learn a new vowel!")
		await alert.visibility_changed		
		for i in range(2):
			parent.spawn_doubleBlock("e",1)
			await get_tree().create_timer(5.0).timeout		
	if Globals.block_free >= Globals.blocks_to_free:
		print("✅ Threshold reached!")
		Globals.block_free = 0  # reset if needed
		emit_signal("request_state_change", get_parent().State.LevelThree)
