extends Node

@onready var hud: HUD = $HUD

# Scenes
const DORM = preload("res://dorm/dorm.tscn")
const MESSAGES = preload("res://hud/messages.tscn")
const PAINT = preload("res://minigames/paint/paint.tscn")
const GAMEOVER = preload("res://managers/gameover.tscn")

const CURSOR: Texture2D = preload("res://hud/Arrow2.png")

var maxSleep = 100
var currentSleep = 50
var maxFood = 100
var currentFood = 50
var maxSocial = 100
var currentSocial = maxSocial
var maxWater = 100
var currentWater = maxWater
var maxAnxiety = 100
var currentAnxiety = maxAnxiety

# Signals
signal global_event(event_name, data)
func emit_event(event_name: String, data = null):
	emit_signal("global_event", event_name, data)
