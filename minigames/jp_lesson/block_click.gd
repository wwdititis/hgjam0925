extends Button

signal block_clicked

func _ready():
	connect("pressed", Callable(self, "_on_button_pressed"))
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _on_button_pressed():
	emit_signal("block_clicked", self)

func _on_mouse_entered():
	Input.set_custom_mouse_cursor(Globals.CURSOR_HAND)

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(Globals.CURSOR_ARROW)
