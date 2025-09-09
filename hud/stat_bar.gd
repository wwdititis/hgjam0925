class_name StatBar extends Control

@onready var stat_bar: StatBar = $"."
@onready var lbstat_bar: Label = $lbstatBar

func set_label(text: String) -> void:
	lbstat_bar.text = text

func set_value(value: float) -> void:
	stat_bar.value = value
