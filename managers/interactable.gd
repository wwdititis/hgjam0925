class_name Interactable extends Area2D

signal interacted(dialog: String)
@export var dialog_text: String = "Default dialog"

func _ready() -> void:
	add_to_group("interactables")
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body.name == "Morgan":
		emit_signal("interacted", dialog_text)
