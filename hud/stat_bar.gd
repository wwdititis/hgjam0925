class_name StatBar extends Control

@onready var lbstat_bar: Label = $lbstat_bar
@export var label: String = "Label"

func _ready() -> void:
	lbstat_bar.text = label
	update_color()

func set_value(value: float) -> void:
	self.value = value
	update_color()

func update_color() -> void:
	var fill_style: StyleBoxFlat = self.get("custom_styles/fill")
	if fill_style != null:
		if self.value < 50:
			fill_style.bg_color = Color.RED
		else:
			fill_style.bg_color = Color.GREEN
