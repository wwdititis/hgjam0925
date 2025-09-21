extends Node
class_name StateManager

@onready var jp_lesson = get_parent()

@onready var diag: TextureRect = $"../CL/diag"
@onready var diag_text: RichTextLabel = $"../CL/diag/diag_text"
@onready var diag_btn: Button = $"../CL/diag/diag_btn"
@onready var diag2: TextureRect = $"../CL/diag2"
@onready var diag2_text: RichTextLabel = $"../CL/diag2/diag2_text"
@onready var diag2_btn: Button = $"../CL/diag2/diag2_btn"

signal change_state(old_state: int, new_state: int)

enum State {
	Tutorial,
	LevelOne,
	LevelTwo,
	LevelThree,
	LevelFour,
	LevelFive,
}

#var state_names: Array = ["Tutorial", "LevelOne", "LevelTwo", "LevelThree", "LevelFour", "LevelFive"]
var state_nodes: Dictionary = {}
var current_state: int = -1

# Map enum -> node. Use exact child node names.
func _enter_tree() -> void:
	# Build the dictionary early (before parent's _ready runs)
	state_nodes[State.Tutorial] = get_node_or_null("Tutorial")
	state_nodes[State.LevelOne] = get_node_or_null("LevelOne")
	state_nodes[State.LevelTwo] = get_node_or_null("LevelTwo")
	state_nodes[State.LevelThree] = get_node_or_null("LevelThree")
	state_nodes[State.LevelFour] = get_node_or_null("LevelFour")
	state_nodes[State.LevelFive] = get_node_or_null("LevelFive")

func _ready() -> void:
	Signals.connect("block_free", Callable(self, "_on_block_freed"))
# Disable all states initially and connect their "request_state_change" signals (if present)
	for node in state_nodes.values():
		if node:
			node.set_process(false)
			node.set_physics_process(false)
			if node.has_signal("request_state_change"):
				node.connect("request_state_change", Callable(self, "change_state_to"))
	#_enter_state(current_state) # Enter the starting state

# Public API to change state (call this)
func change_state_to(new_state: int) -> void:
	if new_state == current_state:
		return
	_exit_state(current_state)
	var _old = current_state
	current_state = new_state
	_enter_state(current_state)
	emit_signal("change_state", current_state)

# Internal helpers
func _enter_state(s: int) -> void:
	var node = state_nodes.get(s, null)
	if node:
		if node.has_method("enter"):
			node.call("enter")
		node.set_process(true)
		node.set_physics_process(true)

func _exit_state(s: int) -> void:
	var node = state_nodes.get(s, null)
	if node:
		if node.has_method("exit"):
			node.call("exit")
		node.set_process(false)
		node.set_physics_process(false)

func _on_block_freed():
	Globals.block_free += 1
	print("Block freed! Count:", Globals.block_free)

func set_diag(message:String, button_text:String):	
	diag.visible = true
	diag_text.text = message
	diag_btn.text = button_text

func set_diag2(message:String, button_text:String):	
	diag2.visible = true
	diag2_text.text = message
	diag2_btn.text = button_text

func _on_diag_btn_pressed() -> void:
	diag.visible = false
	match current_state:
		State.Tutorial:
			$Tutorial.Tutorial()
		State.LevelOne:
			$LevelOne.Lvl1()
		State.LevelTwo:
			$LevelTwo.Lvl2()		
		State.LevelThree:
			$LevelThree.Lvl3()	
		State.LevelFour:
			$LevelFour.Lvl4()				
	
func _on_diag2_btn_pressed() -> void:
	diag2.visible = false
