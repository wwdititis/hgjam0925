extends Node2D

func _ready():
	test_viewport()
	
func test_viewport() -> void:
	var viewport := SubViewport.new()
	viewport.size = Vector2(256, 256)
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	viewport.transparent_bg = false
	add_child(viewport)

	# Add a white background
	var bg := ColorRect.new()
	bg.color = Color.WHITE
	bg.size = viewport.size
	viewport.add_child(bg)
	bg.move_to_front() # make sure background covers behind

	# Add a red line
	var line := Line2D.new()
	line.points = [Vector2(0, 0), Vector2(256, 256)]
	line.width = 8
	line.default_color = Color.RED
	viewport.add_child(line)


	await get_tree().process_frame
	await get_tree().process_frame # wait two frames just in case

	var img := viewport.get_texture().get_image()
	img.save_png("res://test.png")
	print("Saved res://test.png")
