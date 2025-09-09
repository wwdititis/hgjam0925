class_name GM extends Node

@onready var hud: HUD = $HUD

# Called when the node enters the scene tree for the first time.
func _ready():
	for interactable in get_tree().get_nodes_in_group("interactables"):
			interactable.connect("interacted", Callable(self, "_on_interacted"))
	if hud:
		print("updating sleep")
		hud.set_sleep(Globals.currentSleep)
		hud.set_dialog_panel("A week to go before I have to move out... And I still don’t even know where I’m headed.")
		await get_tree().create_timer(4.0).timeout
		hud.set_dialog_panel("I've left so many things unfinished.")
		await get_tree().create_timer(4.0).timeout
		hud.set_dialog_panel("I feel like I failed at everything.")
		await get_tree().create_timer(4.0).timeout
		hud.set_dialog_panel("*sigh* I better start going through it all...")
		
		
func _on_interacted(dialog: String) -> void:
	hud.set_dialog_panel(dialog)

			
func gameover():		
	#$timerHealth.stop()
	get_tree().current_scene.add_child(Globals.GAMEOVER.instantiate())		

	
