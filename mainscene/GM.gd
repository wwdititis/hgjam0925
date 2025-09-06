extends Node2D
#class_name GameManager

@onready var HUD: Node = $HUD

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("_init_hud")
	#HUD.set_sleepbar(50.0)
	#$timerHealth.start()
	#sleeplb.text = "sleep"
	#foodlb.text = "food"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_health_timeout():
	Globals.currentSleep -= 10
	Globals.currentFood -= 5
	#sleepChanged()
	#foodChanged()
	if Globals.currentSleep <= 0:
		gameover()
		
func gameover():		
	$timerHealth.stop()
	get_tree().current_scene.add_child(Globals.gameover.instantiate())		

#func sleepChanged():		
	#sleepbar.value = Globals.currentSleep * 100 / Globals.maxSleep
	
	
#func foodChanged():		
	#foodbar.value = Globals.currentFood * 100 / Globals.maxFood	

func _on_health_changed() -> void:
	pass # Replace with function body.


func _on_paint_pressed() -> void:
	get_tree().change_scene_to_packed(Globals.paint)
