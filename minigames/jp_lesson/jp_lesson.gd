extends Node2D

@onready var sm: StateManager = $StateManager
@onready var lbscore: Label = $lbscore
var score:int = 0

var double_block := preload("res://minigames/jp_lesson/fallingBlock_double.tscn")
var triple_block := preload("res://minigames/jp_lesson/fallingBlock_triple.tscn")
var blockSprites := {
	"a": [preload("res://minigames/jp_lesson/letters/aj.png"),preload("res://minigames/jp_lesson/letters/a.png")],
	"i": [preload("res://minigames/jp_lesson/letters/ij.png"),preload("res://minigames/jp_lesson/letters/i.png")],
	"e": [preload("res://minigames/jp_lesson/letters/ej.png"),preload("res://minigames/jp_lesson/letters/e.png")],
	"u": [preload("res://minigames/jp_lesson/letters/uj.png"),preload("res://minigames/jp_lesson/letters/u.png")],
	"o": [preload("res://minigames/jp_lesson/letters/oj.png"),preload("res://minigames/jp_lesson/letters/o.png")],
}
var tutorial := true
var lvl1 := false
var lvl2 := false
var lvl3 := false
var lvl4 := false
var newBlock
var letter
var remaining
var correct_block = false

@onready var spawn_area: Area2D = $SpawnArea

func _ready() -> void:
	randomize()
	sm.change_state_to(sm.State.Tutorial)

func spawn_doubleBlock(vowel: String, x: int) -> void:
	letter = vowel
	remaining = x
	if remaining <= 0:
		return
	newBlock = double_block.instantiate()
	var op1 = newBlock.get_node("OP1sprite")
	op1.connect("sprite_clicked", Callable(self, "_skip_doubleBlock").bind(newBlock))
	var spawn_position = get_non_overlapping_position()
	newBlock.position = spawn_position
	newBlock.gravity_scale = 0.05
	add_child(newBlock)
	var sprite_paths = blockSprites[letter]
	newBlock.get_node("JPsprite").texture = sprite_paths[0]
	newBlock.get_node("OP1sprite").texture = sprite_paths[1]
	await get_tree().create_timer(5.0).timeout
	spawn_doubleBlock(letter, remaining-1)
	
func spawn_tripleBlock(vowel: String, x: int) -> void:
	letter = vowel
	remaining = x
	if remaining <= 0:
		return
	newBlock = triple_block.instantiate()
	var op1 = newBlock.get_node("OP1sprite")
	var op2 = newBlock.get_node("OP2sprite")
	op1.connect("sprite_clicked", Callable(self, "_is_correct").bind(newBlock))
	op2.connect("sprite_clicked", Callable(self, "_is_correct").bind(newBlock))
	var spawn_position = get_non_overlapping_position()
	newBlock.position = spawn_position
	newBlock.gravity_scale = 0.05
	add_child(newBlock)
	
	# --- picks correct JP + romaji pair ---
	var sprite_paths = blockSprites[letter]
	var jp_sprite = sprite_paths[0]
	var correct_romaji = sprite_paths[1]	
	
	# --- picks a random wrong romaji sprite ---
	var wrong_romaji
	if letter == "a":
		var wrong = blockSprites["i"]
		wrong_romaji = wrong[1]
	else:
		wrong_romaji = random_ENSprite(letter)	
	
	# --- randomizes positions ---
	var romaji_options = [correct_romaji, wrong_romaji]
	romaji_options.shuffle()
	
	# --- assigns ---
	newBlock.get_node("JPsprite").texture = jp_sprite
	newBlock.get_node("OP1sprite").texture = romaji_options[0]
	newBlock.get_node("OP2sprite").texture = romaji_options[1]	
	
	# store which one is correct
	if newBlock.get_node("OP1sprite").texture == correct_romaji:
		newBlock.set_meta("correct_option", "OP1sprite")
	else:
		newBlock.set_meta("correct_option", "OP2sprite")	
	
	print("waiting 7s")
	await get_tree().create_timer(7.0).timeout
	spawn_tripleBlock(letter, remaining-1)	

func _is_correct(clicked_node: Node, block: Node):
	var correct_node_name = block.get_meta("correct_option")
	if clicked_node.name == correct_node_name:
		update_score(1)
		Signals.emit_signal("block_free")
		block.call_deferred("queue_free")
		spawn_tripleBlock(letter, remaining-1)	
	else:
		print("❌ Wrong!")	
		block.gravity_scale = 3.0
	
func random_ENSprite(exclude_char: String):
	var keys = blockSprites.keys()
	var random_key
	if lvl4:
		keys.erase(exclude_char)  # remove the excluded one
		random_key = keys[randi() % keys.size()]
		return blockSprites[random_key][-1]
	var index = keys.find(exclude_char)
	var allowed_keys = keys.slice(0, index)
	print("allowed keys:"+str(allowed_keys))
	random_key = allowed_keys[randi() % allowed_keys.size()]
	return blockSprites[random_key][-1]

func _skip_doubleBlock(_clicked_node: Node, block: Node):
	update_score(1)
	Signals.emit_signal("block_free")
	block.call_deferred("queue_free")

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

func update_score(x:int):
	score += x
	lbscore.text = str(score)

func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()
