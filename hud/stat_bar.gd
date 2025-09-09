class_name StatBar extends Control

@onready var stat_bar: StatBar = $"."
@onready var lbstat_bar: Label = $lbstat_bar
@export var label: String = "Label"

func _ready() -> void:
	lbstat_bar.text = label

func set_value(value: float) -> void:
	stat_bar.value = value
