extends Node
class_name StateMachine

signal change_state(old_state: int, new_state: int)

enum State {
	Tutorial,
	LevelOne,
	LevelTwo,
}

var current_state: int = State.Tutorial

# Map enum -> node. Use exact child node names.
@onready var state_nodes : Dictionary = {
	State.Tutorial: get_node("Tutorial"),
	State.LevelOne: get_node("LevelOne"),
	State.LevelTwo: get_node("LevelTwo"),
}

func _ready() -> void:
# Disable all states initially and connect their "request_state_change" signals (if present)
	for node in state_nodes.values():
		if node:
			node.set_process(false)
			node.set_physics_process(false)
			if node.has_signal("request_state_change"):
				node.connect("request_state_change", Callable(self, "change_state_to"))
	# Enter the starting state
	_enter_state(current_state)

# Public API to change state (call this)
func change_state_to(new_state : int) -> void:
	if not state_nodes.has(new_state):
		push_warning("StateMachine: unknown state: %s" % str(new_state))
		return
	if new_state == current_state:
		return
	var old := current_state
	_exit_state(old)
	current_state = new_state
	emit_signal("change_state", old, new_state)
	_enter_state(new_state)

# Internal helpers
func _exit_state(s : int) -> void:
	var node = state_nodes.get(s, null)
	if node:
		if node.has_method("exit"):
			node.call("exit")
	node.set_process(false)
	node.set_physics_process(false)

func _enter_state(s : int) -> void:
	var node = state_nodes.get(s, null)
	if node:
		if node.has_method("enter"):
			node.call("enter")
		node.set_process(true)
		node.set_physics_process(true)


#func _process(delta: float) -> void:
	#match current_state:
		#State.Tutorial:
			#pass
		#State.LevelOne:
			#pass
