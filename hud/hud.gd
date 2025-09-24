class_name HUD extends Node2D

@onready var gm: GM = $"../GameManager"
@onready var dorm: Node2D = $"../Dorm"

@onready var sleep_bar: StatBar = $CanvasLayer/stats/needs/sleep_bar
@onready var social_bar: StatBar = $CanvasLayer/stats/needs/social_bar
@onready var food_bar: StatBar = $CanvasLayer/stats/needs/food_bar
@onready var water_bar: StatBar = $CanvasLayer/stats/needs/water_bar
@onready var anxiety_bar: StatBar = $CanvasLayer/stats/anxiety_bar

@onready var dialog_container: PanelContainer = $CanvasLayer/dialog_container
@onready var dialog_panel: RichTextLabel = $CanvasLayer/dialog_container/dialog_panel
@onready var lb_instructions: RichTextLabel = $CanvasLayer/lb_instructions

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
	dialog_container.visible = true
	lb_instructions.text = "Press ENTER to continue"
	dialog_panel.text = "A week to go before I have to move out... And I still don’t even know where I’m headed."
	await wait_for_key("ui_accept")
	dialog_panel.text = "I've got so many things unfinished. I feel like I failed at everything."
	await wait_for_key("ui_accept")
	dialog_panel.text = "I'm exhausted *sigh*, but eventually, I'll have to go through it all. One thing at a time... that should make it easier."
	await wait_for_key("ui_accept")
	dialog_container.visible = false
	Globals.movement_enabled = true
	lb_instructions.text = "Use ARROW keys to move around"
	await wait_for_key(["ui_up", "ui_down", "ui_left", "ui_right"])
	lb_instructions.text = ""
	dorm.bed.disabled = false
	
func dialog_lesson():		
	Globals.movement_enabled = false
	dialog_container.visible = true
	lb_instructions.text = "Press ENTER to continue"
	dialog_panel.text = "Oh wow, my japanese textbook. I was really excited to learn a new language...not even sure why I gave it up..."
	await wait_for_key("ui_accept")	
	dialog_panel.text = "Maybe... Maybe there's still time."
	await wait_for_key("ui_accept")
	add_child(Globals.LESSON.instantiate())
	Globals.movement_enabled = true
	
func wait_for_key(actions) -> void:
	var pressed := false
	if typeof(actions) == TYPE_STRING:
		actions = [actions]  # wrap single action into array
	# Wait until any of the actions are pressed
	while not pressed:
		await get_tree().process_frame
		for action in actions:
			if Input.is_action_just_pressed(action):
				pressed = true
				break
	# Wait until all those actions are released before continuing
	var still_down := true
	while still_down:
		await get_tree().process_frame
		still_down = false
		for action in actions:
			if Input.is_action_pressed(action):
				still_down = true
				break
