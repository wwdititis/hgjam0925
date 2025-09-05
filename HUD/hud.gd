extends Node2D

@onready var messages: Node2D = $CanvasLayer/messages


func _ready() -> void:
	messages.visible = false


func _on_phone_pressed() -> void:
	messages.visible = true
