class_name GM extends Node

@onready var hud: HUD = $"../HUD"

# Called when the node enters the scene tree for the first time.
func _ready():
	for interactable in get_tree().get_nodes_in_group("interactables"):
			interactable.connect("interacted", Callable(self, "_on_interacted"))
 
	Globals.connect("global_event", Callable(self, "_on_global_event"))
	
		
func _on_global_event(event_name: String, data):
	match event_name:
		"player_died":
			print("Player died! Data:", data)
			# handle player death
		"decrease_sleep":
			hud.set_sleep(Globals.current_stat["sleep"] - 10)
		"increase_sleep": 
			hud.set_sleep(Globals.current_stat["sleep"] + 10)			
		_:
			print("Unknown global event:", event_name)		
		
func _on_interacted(dialog: String) -> void:
	hud.dialog_container.visible = true
	hud.dialog_panel.text = dialog
	await get_tree().create_timer(5.0).timeout
	hud.dialog_container.visible = false
			
func gameover():		
	#$timerHealth.stop()
	get_tree().current_scene.add_child(Globals.GAMEOVER.instantiate())		
	
	
	


	
