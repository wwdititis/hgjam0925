extends Node2D

var fallingBlock = preload("res://minigames/jap/fallingBlock.tscn")
var blockSprites = {
	"a": [preload("res://minigames/jap/letters/aj.png"),preload("res://minigames/jap/letters/a.png")],
	"i": [preload("res://minigames/jap/letters/ij.png"),preload("res://minigames/jap/letters/i.png")],
	"e": [preload("res://minigames/jap/letters/ij.png"),preload("res://minigames/jap/letters/i.png")],
	"u": [preload("res://minigames/jap/letters/ij.png"),preload("res://minigames/jap/letters/i.png")],
	"o": [preload("res://minigames/jap/letters/ij.png"),preload("res://minigames/jap/letters/i.png")],
}
var lvl0 = false
var PhaseI = false
@onready var diag2: AcceptDialog = $Howto2
var newBlock
@onready var timer: Timer = $Timer
@onready var spawn_area: Area2D = $SpawnArea

func _ready():
	lvl0 = true
	
func Phase1():
	spawnBlock("a",3)
	await get_tree().create_timer(10.0).timeout
	spawnBlock("i",3)
	#timer.start()
	
func Phase2():
	spawnBlock("a",3)
	await get_tree().create_timer(10.0).timeout
	spawnBlock("i",3)
	#timer.start()	

func spawnBlock(pair: String, x: int) -> void:
	for i in x:
		newBlock = fallingBlock.instantiate()
		var spawn_position = get_non_overlapping_position()
		newBlock.position = spawn_position
		add_child(newBlock)
		var sprite_paths = blockSprites[pair]
		if sprite_paths.size() >= 1:
			newBlock.get_node("JPsprite").texture = sprite_paths[0]
		if sprite_paths.size() >= 2:
			newBlock.get_node("ENsprite").texture = sprite_paths[1]
		var sprite_clicked = newBlock.get_node("ENsprite")
		if lvl0 == false:
			sprite_clicked.connect("sprite_clicked", Callable(self, "spawnBlock"))
		await get_tree().create_timer(5.0).timeout

func _on_timer_timeout():
	pass
	#spawnBlock()

func get_non_overlapping_position() -> Vector2:
	var max_attempts = 20
	var pos: Vector2
	for i in range(max_attempts):
		pos = get_random_point_in_area()
		var query = PhysicsPointQueryParameters2D.new()
		query.position = pos
		query.collision_mask = 1  # only check against layer 1
		var space = get_world_2d().direct_space_state
		var result = space.intersect_point(query)
		if result.is_empty():
			return pos
	return get_random_point_in_area() # fallback

func get_random_point_in_area() -> Vector2:
	var shape = spawn_area.get_node("CollisionShape2D").shape
	var extents = shape.extents
	var local_x = randf_range(-extents.x, extents.x)
	var local_y = randf_range(-extents.y, extents.y)
	return spawn_area.global_position + Vector2(local_x, local_y)

func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()

func _on_howto_confirmed() -> void:
	for i in 2:
		spawnBlock("a",1)
		await get_tree().create_timer(4.0).timeout
	diag2.visible = true

func _on_phase1_confirmed() -> void:
	lvl0 = false
	Phase1()
