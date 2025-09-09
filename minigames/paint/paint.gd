extends Node2D

@onready var btnEraser: Button = $btnEraser
var eraser_mode := false

@onready var draw_area: Area2D = $DrawArea
@onready var line_container: Node2D = $LineContainer
var _pressed := false
var current_line: Line2D = null
# 🔹 grid size for snapping (1 = pixel-perfect, 4 = chunky pixel-art style)
var grid_size: int = 16

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if can_draw_at(event.position):
				_pressed = true
				current_line = Line2D.new()
				current_line.default_color = Color(0.0, 0.5, 1.0)
				current_line.width = 16
				line_container.add_child(current_line)

				# snap to grid
				var p := line_container.to_local(snap_to_grid(event.position, grid_size))

				# 👇 add two points (tiny offset) so single clicks are visible
				current_line.add_point(p)
				current_line.add_point(p + Vector2(16, 0)) # pixel dot
		else:
			_pressed = false
			current_line = null

	elif event is InputEventMouseMotion and _pressed and current_line:
		if can_draw_at(event.position):
			var snapped := snap_to_grid(event.position, grid_size)
			current_line.add_point(line_container.to_local(snapped))


# 🔹 Snap any position to grid
func snap_to_grid(pos: Vector2, g: int) -> Vector2:
	return Vector2(
		round(pos.x / g) * g,
		round(pos.y / g) * g
	)


# 🔹 Check if mouse is inside DrawArea
func can_draw_at(pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = pos
	params.collide_with_areas = true
	params.collide_with_bodies = false

	var results = space_state.intersect_point(params, 8)
	for r in results:
		if r.collider == draw_area:
			return true
	return false

func _ready() -> void:
	btnEraser.toggled.connect(func(toggled: bool):
		eraser_mode = toggled
	)

func _on_exit_pressed() -> void:
	queue_free()

func _on_clear_pressed() -> void:
	for child in line_container.get_children():
		child.queue_free()
