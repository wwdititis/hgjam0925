extends Node2D

@onready var draw_area: Area2D = $DrawArea
@onready var line2d: Line2D = $Line2D
@onready var shape: CollisionShape2D = $DrawArea/CollisionShape2D

var _pressed = false
var current_line: Line2D = null

# 🔹 Grid settings
var grid_size: int = 16
var grid_color: Color = Color.BLACK

func _ready() -> void:
	queue_redraw()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:				
				if can_draw_at(event.position):
					_pressed = true
					current_line = Line2D.new()
					current_line.default_color = Color.BLUE
					current_line.width = 16
					line2d.add_child(current_line)
					# snap to grid
					var p := line2d.to_local(snap_to_grid(event.position, grid_size))
					current_line.add_point(p)
					current_line.add_point(p + Vector2(16, 0)) #size of pixel dot
			else:
				_pressed = false
				current_line = null
	elif event is InputEventMouseMotion and _pressed and current_line:
		if can_draw_at(event.position):
			var snapped := snap_to_grid(event.position, grid_size)
			current_line.add_point(line2d.to_local(snapped))

# Snap any position to grid	
func snap_to_grid(pos: Vector2, g: int) -> Vector2:
	return Vector2(
		round(pos.x / g) * g,
		round(pos.y / g) * g
	)

# Check if mouse is inside DrawArea
func can_draw_at(pos: Vector2) -> bool:
	# Convert global mouse pos to local coords of draw_area
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
	
# Draw grid inside DrawArea only
func _draw() -> void:
	if shape.shape is RectangleShape2D:
		var rect_shape: RectangleShape2D = shape.shape as RectangleShape2D
		var half_extents: Vector2 = rect_shape.extents

		# Get the global transform of the draw area
		var xform: Transform2D = draw_area.get_global_transform()

		# Convert DrawArea's center into this Node2D's local space
		var center: Vector2 = to_local(xform.origin)

		# Rectangle corners in local space
		var top_left: Vector2 = center - half_extents
		var bottom_right: Vector2 = center + half_extents

		# Vertical grid lines
		for x in range(int(top_left.x), int(bottom_right.x), grid_size):
			draw_line(Vector2(x, top_left.y), Vector2(x, bottom_right.y), grid_color, 1.0)

		# Horizontal grid lines
		for y in range(int(top_left.y), int(bottom_right.y), grid_size):
			draw_line(Vector2(top_left.x, y), Vector2(bottom_right.x, y), grid_color, 1.0)
	

func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_packed(Globals.room)
