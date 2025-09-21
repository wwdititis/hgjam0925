extends RigidBody2D

func _on_body_entered(body: Node):
	print("Collided with:", body.name, " Groups:", body.get_groups())
	if body.is_in_group("floor"):
		print("FLOOR HIT -> freeing block")
		queue_free()
		Signals.emit_signal("block_free")
