extends Node
class_name StateManager

@onready var diag_tutorial: AcceptDialog = $"../diag_tutorial"
@onready var diag_lvl1: AcceptDialog = $"../diag_lvl1"

signal change_state(old_state: int, new_state: int)

enum State {
	Tutorial,
	LevelOne,
	LevelTwo,
}

var state_names: Array = ["Tutorial", "LevelOne", "LevelTwo"]
var state_nodes: Dictionary = {}
var current_state: int = -1

# Map enum -> node. Use exact child node names.
func _enter_tree() -> void:
	# Build the dictionary early (before parent's _ready runs)
	state_nodes[State.Tutorial] = get_node_or_null("Tutorial")
	state_nodes[State.LevelOne] = get_node_or_null("LevelOne")
	state_nodes[State.LevelTwo] = get_node_or_null("LevelTwo")

func _ready() -> void:
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
	var old = current_state
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


#func _process(delta: float) -> void:
	#match current_state:
		#State.Tutorial:
			#pass
		#State.LevelOne:
			#pass
