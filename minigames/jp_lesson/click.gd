extends Sprite2D

signal sprite_clicked
@onready var block: RigidBody2D = $".."

var mouse_inside := false

func _input(event):
	var pos = get_local_mouse_position()
	var inside = is_pixel_opaque(pos)

	# Handle mouse enter / exit
	if event is InputEventMouseMotion:
		if inside and not mouse_inside:
			print("Mouse entered sprite")
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
			mouse_inside = true
		elif not inside and mouse_inside:
			print("Mouse exited sprite")
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
			mouse_inside = false

	# Handle mouse click
	if event is InputEventMouseButton:
		if inside and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Sprite clicked!")
			sprite_clicked.emit()
			block.queue_free()
		elif not inside and mouse_inside:
			print("Mouse exited sprite")				
