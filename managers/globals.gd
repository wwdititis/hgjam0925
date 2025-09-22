extends Node

# Scenes
const DORM := preload("res://dorm/dorm.tscn")
const MESSAGES := preload("res://hud/messages.tscn")
const LESSON := preload("res://minigames/jp_lesson/jp_lesson.tscn")
const PAINT := preload("res://minigames/paint/paint.tscn")
const GAMEOVER := preload("res://managers/gameover.tscn")

const CURSOR_ARROW: Texture2D = preload("res://hud/Arrow2.png")
const CURSOR_HAND: Texture2D = preload("res://hud/Hand3.png")

var movement_enabled: bool = false
var sleep_enabled: bool = false

var current_stat := {
	"sleep" = 100,
	"social" = 100,
	"food" = 100,
	"water" = 100,
	"anxiety" = 100,
}

var block_free:int = 0
var blocks_to_free:int

# Signals
signal global_event(event_name, data)
func emit_event(event_name: String, data = null):
	emit_signal("global_event", event_name, data)
	
