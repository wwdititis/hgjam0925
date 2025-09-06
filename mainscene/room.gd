extends Node2D

@onready var paint: Button = $paint
@onready var dialog: RichTextLabel = $PanelContainer/dialog
@onready var dpanel: PanelContainer = $PanelContainer

func _ready() -> void:
	dpanel.visible = false

func _on_paint_pressed() -> void:
	get_tree().change_scene_to_packed(Globals.paint)

func _on_edoor_body_entered(body: Node2D) -> void:
	set_dialog("I don't feel like leaving the house today...")
	
func _on_bdoor_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	set_dialog("I don't need to go to the bathroom.")	
	
func set_dialog(text):
	dpanel.visible = true
	dialog.text = text
	await get_tree().create_timer(4.0).timeout
	dpanel.visible = false
