extends Area2D

func _on_body_entered(body):
	if body is RigidBody2D:
		body.queue_free()
		return
	body.update_health(transition.player_health)
	if body.is_in_group("Player"):
		$gameOver.play()

