extends Node
class_name StateManager

@onready var jp_lesson = get_parent()

@onready var diag_tutorial0: AcceptDialog = $"../diag_tutorial0"
@onready var diag_tutorial1: AcceptDialog = $"../diag_tutorial1"
@onready var diag_tutorial2: AcceptDialog = $"../diag_tutorial2"
@onready var alert: ColorRect = $"../alert"
@onready var lb_alert: Label = $"../alert/lb_alert"

signal change_state(old_state: int, new_state: int)

enum State {
	Tutorial,
	LevelOne,
	LevelTwo,
	LevelThree,
	LevelFour,
	LevelFive,
}

var state_names: Array = ["Tutorial", "LevelOne", "LevelTwo", "LevelThree", "LevelFour", "LevelFive"]
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
	Signals.connect("alert_jplesson", Callable(self, "_on_alert"))
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

func _on_diag_tutorial0_confirmed() -> void:
	$Tutorial.Tutorial()

func _on_diag_tutorial1_confirmed() -> void:
	$LevelOne.Lvl1()

func _on_diag_tutorial2_confirmed() -> void:
	$LevelTwo.Lvl2()

func _on_btn_alert_pressed() -> void:
	Signals.emit_signal("alert_jplesson")
	
func _on_alert():	
	alert.visible = false

func message_alert(message:String):	
	lb_alert.text = message
