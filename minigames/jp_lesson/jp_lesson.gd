extends Node2D

@onready var sm: StateManager = $StateManager
@onready var lbscore: Label = $lbscore
var score:int = 0

var fallingBlock := preload("res://minigames/jp_lesson/fallingBlock.tscn")
var blockSprites := {
	"a": [preload("res://minigames/jp_lesson/letters/aj.png"),preload("res://minigames/jp_lesson/letters/a.png")],
	"i": [preload("res://minigames/jp_lesson/letters/ij.png"),preload("res://minigames/jp_lesson/letters/i.png")],
	"e": [preload("res://minigames/jp_lesson/letters/ij.png"),preload("res://minigames/jp_lesson/letters/i.png")],
	"u": [preload("res://minigames/jp_lesson/letters/ij.png"),preload("res://minigames/jp_lesson/letters/i.png")],
	"o": [preload("res://minigames/jp_lesson/letters/ij.png"),preload("res://minigames/jp_lesson/letters/i.png")],
}
var tutorial = false
@onready var diag2: AcceptDialog = $Howto2
var newBlock
var letter
var remaining
@onready var timer: Timer = $Timer
@onready var spawn_area: Area2D = $SpawnArea

func _ready() -> void:
	sm.change_state_to(sm.State.Tutorial)
	
func Tutorial():	
	for i in range(3):
		spawnBlock("a",1)
		await get_tree().create_timer(4.0).timeout
	tutorial = false
	sm.change_state_to(sm.State.LevelOne)
		
func Lvl1():
	print("Start Lvl1")
	spawnBlock("a",2)
	await get_tree().create_timer(5.0).timeout
	spawnBlock("i",3)
	
func Lvl2():
	print("Start Lvl2")
	spawnBlock("a",3)
	await get_tree().create_timer(10.0).timeout
	spawnBlock("i",3)
	#timer.start()	

func spawnBlock(char: String, x: int) -> void:
	letter = char
	remaining = x
	if remaining <= 0:
		return
	newBlock = fallingBlock.instantiate()
	var sprite_clicked = newBlock.get_node("OP1sprite")
	sprite_clicked.connect("sprite_clicked", Callable(self, "_skip_block"))
	var spawn_position = get_non_overlapping_position()
	newBlock.position = spawn_position
	add_child(newBlock)
	var sprite_paths = blockSprites[letter]
	if sprite_paths.size() >= 1:
		newBlock.get_node("JPsprite").texture = sprite_paths[0]
	if sprite_paths.size() >= 2:
		newBlock.get_node("OP1sprite").texture = sprite_paths[1]
	#if not tutorial:
	print("waiting 5s")
	await get_tree().create_timer(5.0).timeout
	spawnBlock(letter, remaining-1)

func _skip_block():
	score += 1
	lbscore.text = str(score)
	print("Signal received in jp_lesson.gd")
	spawnBlock(letter, remaining-1)

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

func _on_diag_tutorial_confirmed() -> void:
	#Tutorial()
	Lvl1()

func _on_diag_lvl1_confirmed() -> void:
	Lvl2()
