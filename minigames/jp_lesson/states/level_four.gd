extends Node

#signal request_state_change(new_state : int)
@onready var sm := get_parent()
@onready var parent := get_parent().get_parent()
@onready var alert: ColorRect = $"../../alert"

func enter(_params : Dictionary = {}) -> void:
	set_process(true)
	print("Entered LevelFour")
	Globals.blocks_to_free = 4
	await get_tree().create_timer(2.0).timeout
	Lvl4()

func Lvl4():
	parent.lvl3 = false
	parent.lvl4 = true
	alert.visible = true
	sm.message_alert("Ready for a new vowel..?")
	await alert.visibility_changed	
	
	parent.spawn_tripleBlock("e",2)
	await get_tree().create_timer(7.0).timeout
	parent.spawn_tripleBlock("u",3)
	await get_tree().create_timer(5.0).timeout	

func exit() -> void:
	set_process(false)
	print("Exited LevelFour")

func _process(_delta: float) -> void:
	if Globals.block_free >= Globals.blocks_to_free:
		print("✅ Threshold reached!")
		Globals.block_free = 0  # reset if needed
		#emit_signal("request_state_change", get_parent().State.LevelFive)
