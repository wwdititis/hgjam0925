extends Sprite2D

signal sprite_clicked
#@onready var block: RigidBody2D = $".."

var mouse_inside := false

func _input(event):
	if not texture:
		return
	var pos = get_local_mouse_position()
	var rect = Rect2(Vector2.ZERO, texture.get_size())
	var inside = rect.has_point(pos)


	# Handle mouse enter / exit
	if event is InputEventMouseMotion:
		if inside and not mouse_inside:
			Input.set_custom_mouse_cursor(Globals.CURSOR_HAND)
			mouse_inside = true
		elif not inside and mouse_inside:
			Input.set_custom_mouse_cursor(Globals.CURSOR_ARROW)
			mouse_inside = false

	# Handle mouse click
	if event is InputEventMouseButton:
		if inside and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("sprite_clicked", self)
