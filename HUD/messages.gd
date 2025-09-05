extends Node2D

@onready var messages: Node2D = $"."


func _on_button_pressed() -> void:
	messages.visible = false
