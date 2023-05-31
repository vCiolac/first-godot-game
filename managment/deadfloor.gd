extends Area2D

func _on_body_entered(body):
	body.update_health(transition.player_health)
	if body.is_in_group("Player"):
		$gameOver.play()
