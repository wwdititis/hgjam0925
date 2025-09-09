class_name HUD extends Node2D

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
	sleep_bar.set_label("sleep")
	social_bar.set_label("social")
	food_bar.set_label("food")
	water_bar.set_label("water")
	anxiety_bar.set_label("anxiety")
	dialog_container.visible = false
	messages.visible = false
	dialog_window.visible = false

func set_sleep(value: float) -> void:
	sleep_bar.set_value(value)
	Globals.currentSleep = value
	
func set_social(value: float) -> void:
	social_bar.set_value(value)	
	Globals.currentSocial = value
	
func set_food(value: float) -> void:
	food_bar.set_value(value)	
	Globals.currentFood = value
	
func set_water(value: float) -> void:
	water_bar.set_value(value)	
	Globals.currentWater = value		
	
func set_anxiety(value: float) -> void:
	anxiety_bar.set_value(value)	
	Globals.currentAnxiety = value		
	
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
	set_sleep(100)
	
func _on_phone_pressed() -> void:
	messages.visible = true	
