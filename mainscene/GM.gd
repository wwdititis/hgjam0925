extends Node2D
class_name GameManager

@onready var sleep: Control = $"../stats/sleep"
@onready var sleepbar = sleep.get_node("statBar")
@onready var sleeplb = sleep.get_node("statBar/lbstatBar")
@onready var food: Control = $"../stats/food"
@onready var foodbar = food.get_node("statBar")
@onready var foodlb = food.get_node("statBar/lbstatBar")


# Called when the node enters the scene tree for the first time.
func _ready():
	#$timerHealth.start()
	sleeplb.text = "sleep"
	foodlb.text = "food"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_health_timeout():
	Globals.currentSleep -= 10
	Globals.currentFood -= 5
	sleepChanged()
	foodChanged()
	if Globals.currentSleep <= 0:
		gameover()
		
func gameover():		
	$timerHealth.stop()
	get_tree().current_scene.add_child(Globals.gameover.instantiate())		

func sleepChanged():		
	sleepbar.value = Globals.currentSleep * 100 / Globals.maxSleep
	
	
func foodChanged():		
	foodbar.value = Globals.currentFood * 100 / Globals.maxFood	

func _on_health_changed() -> void:
	pass # Replace with function body.
