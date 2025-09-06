extends Node2D

var sleepbar: ProgressBar
var sleeplb: Label
@onready var foodbar: Node = $CanvasLayer/stats/bar2/statBar
@onready var foodlb: Node = $CanvasLayer/stats/bar2/statBar/lbstatBar
@onready var messages: Node2D = $CanvasLayer/messages


func _ready() -> void:
	call_deferred("_init_sleep_nodes")
	var sleep_node = $CanvasLayer/stats/bar1
	sleepbar = sleep_node.get_node("statBar") as ProgressBar
	sleeplb = sleep_node.get_node("statBar/lbstatBar") as Label
	sleeplb.text = "sleep"
	foodlb.text = "food"
	messages.visible = false

func set_sleepbar(value: float) -> void:
	sleepbar.value = value 

func set_foodbar(value: float) -> void:
	foodbar.value = value 

func _on_phone_pressed() -> void:
	messages.visible = true
