extends Node

# Scenes
const DORM := preload("res://dorm/dorm.tscn")
const MESSAGES := preload("res://hud/messages.tscn")
const PAINT := preload("res://minigames/paint/paint.tscn")
const GAMEOVER := preload("res://managers/gameover.tscn")

const CURSOR: Texture2D = preload("res://hud/Arrow2.png")

var current_stat := {
	"sleep" = 100,
	"social" = 100,
	"food" = 100,
	"water" = 100,
	"anxiety" = 100,
}

# Signals
signal global_event(event_name, data)
func emit_event(event_name: String, data = null):
	emit_signal("global_event", event_name, data)
	
