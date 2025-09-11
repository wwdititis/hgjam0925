class_name HUD extends Node2D

@onready var gm: GM = $"../GameManager"

@onready var sleep_bar: StatBar = $CanvasLayer/stats/needs/sleep_bar
@onready var social_bar: StatBar = $CanvasLayer/stats/needs/social_bar
@onready var food_bar: StatBar = $CanvasLayer/stats/needs/food_bar
@onready var water_bar: StatBar = $CanvasLayer/stats/needs/water_bar
@onready var anxiety_bar: StatBar = $CanvasLayer/stats/anxiety_bar

@onready var dialog_container: PanelContainer = $CanvasLayer/dialog_container
@onready var dialog_panel: RichTextLabel = $CanvasLayer/dialog_container/dialog_panel

@onready var messages: Node2D = $CanvasLayer/messages
@onready var dialog_window: ConfirmationDialog = $CanvasLayer/dialog_window

func _ready():
	game_init()
	dialog_intro()

func game_init() -> void:
	set_sleep(50)
	set_social(100)
	set_food(50)
	set_water(100)
	set_anxiety(100)
	dialog_container.visible = false
	dialog_window.visible = false

func set_sleep(value: float) -> void:
	sleep_bar.set_value(value)
	Globals.current_stat["sleep"] = value
	
func set_social(value: float) -> void:
	social_bar.set_value(value)	
	Globals.current_stat["social"] = value
	
func set_food(value: float) -> void:
	food_bar.set_value(value)	
	Globals.current_stat["food"] = value
	
func set_water(value: float) -> void:
	water_bar.set_value(value)	
	Globals.current_stat["water"] = value		
	
func set_anxiety(value: float) -> void:
	anxiety_bar.set_value(value)	
	Globals.current_stat["anxiety"] = value		
	
func set_dialog_panel(value: String) -> void:
	dialog_panel.text = value
	dialog_container.visible = true
	await get_tree().create_timer(4.0).timeout
	dialog_container.visible = false
	
func set_dialog_window(title: String, text: String) -> void:	
	dialog_window.visible = true
	dialog_window.title = title
	dialog_window.dialog_text = text
	
func _on_dialog_window_confirmed() -> void:
	Globals.emit_event("increase_sleep", "bed")
	
func _on_phone_pressed() -> void:
	messages.visible = true	

# DIALOGUES
func dialog_intro():		
	set_dialog_panel("A week to go before I have to move out... And I still don’t even know where I’m headed.")
	await get_tree().create_timer(4.0).timeout
	set_dialog_panel("I've left so many things unfinished.")
	await get_tree().create_timer(4.0).timeout
	set_dialog_panel("I feel like I failed at everything.")
	await get_tree().create_timer(4.0).timeout
	set_dialog_panel("*sigh* I better start going through it all...")	
