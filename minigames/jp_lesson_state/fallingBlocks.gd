extends RigidBody2D

func _on_body_entered(body: Node):
	if body.is_in_group("floor"):
		queue_free()
		#get_tree().root.get_node("Jap")._on_timer_timeout()
