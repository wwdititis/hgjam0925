extends Node2D

const PENCIL: Texture2D = preload("res://minigames/paint/pencil.png")
const ERASER: Texture2D = preload("res://minigames/paint/eraser.png")

@onready var btnEraser: Button = $btnEraser
var eraser_mode := false
var eraser_radius: float = 0.0

@onready var draw_area: Area2D = $DrawArea
@onready var line_container: Node2D = $LineContainer
var _pressed := false
var current_line: Line2D = null
# 🔹 grid size for snapping (1 = pixel-perfect, 4 = chunky pixel-art style)
var grid_size: int = 16

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if eraser_mode:
				if can_draw_at(event.position):
					erase_at(event.position)
			else:
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

	elif event is InputEventMouseMotion:
		if eraser_mode and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
			if can_draw_at(event.position):
				erase_at(event.position)
		elif _pressed and current_line:
			if can_draw_at(event.position):
				var snapped := snap_to_grid(event.position, grid_size)
				current_line.add_point(line_container.to_local(snapped))

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

# 🔹 Snap any position to grid
func snap_to_grid(pos: Vector2, g: int) -> Vector2:
	return Vector2(round(pos.x / g) * g, round(pos.y / g) * g)

func erase_at(global_pos: Vector2) -> void:
	# convert click to the same local space used by stroke points
	var local_pos: Vector2 = line_container.to_local(global_pos)
	# iterate strokes; remove first stroke that has a point close enough
	for child in line_container.get_children():
		if child is Line2D:
			# child.points is an array of Vector2 points
			for pt in child.points:
				if pt.distance_to(local_pos) <= eraser_radius:
					child.queue_free()
					return  # remove only the first hit stroke; remove "return" to delete all matches	

func _ready() -> void:
	Input.set_custom_mouse_cursor(PENCIL, Input.CURSOR_ARROW, Vector2(0,0))
	eraser_radius = grid_size * 0.75

func _on_btn_eraser_toggled(toggled_on: bool) -> void:
	eraser_mode = toggled_on
	if eraser_mode:
		_pressed = false
		current_line = null
		Input.set_custom_mouse_cursor(ERASER, Input.CURSOR_ARROW, Vector2(0,0))
	else:
		Input.set_custom_mouse_cursor(PENCIL, Input.CURSOR_ARROW, Vector2(0,0))

func _on_clear_pressed() -> void:
	for child in line_container.get_children():
		child.queue_free()		

func _on_exit_pressed() -> void:
	Input.set_custom_mouse_cursor(Globals.CURSOR, Input.CURSOR_ARROW, Vector2(0,0))
	Globals.emit_event("sleep_depleted", "paint.gd")
	queue_free()
