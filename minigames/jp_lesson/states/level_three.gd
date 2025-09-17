extends Node

@onready var parent := get_parent().get_parent()
@onready var alert: ColorRect = $"../../alert"
@onready var sm := get_parent()

signal request_state_change(new_state : int)
#@onready var sm := get_parent()

func enter(_params : Dictionary = {}) -> void:
	set_process(true)
	print("Entered LevelThree")
	Globals.blocks_to_free = 8
	await get_tree().create_timer(2.0).timeout
	Lvl3()

func Lvl3():
	parent.lvl2 = false
	parent.lvl3 = true
	parent.spawn_tripleBlock("i",2)
	await get_tree().create_timer(7.0).timeout
	parent.spawn_tripleBlock("e",3)
	await get_tree().create_timer(5.0).timeout	

func exit() -> void:
	set_process(false)
	print("Exited LevelThree")

func _process(_delta: float) -> void:
	if Globals.block_free == 4:
		Globals.block_free +=1
		alert.visible = true
		sm.message_alert("Keep going!")
		await alert.visibility_changed		
		for i in range(2):
			parent.spawn_doubleBlock("u",1)
			await get_tree().create_timer(5.0).timeout			
	if Globals.block_free >= Globals.blocks_to_free:
		print("✅ Threshold reached!")
		Globals.block_free = 0  # reset if needed
		emit_signal("request_state_change", get_parent().State.LevelFour)
