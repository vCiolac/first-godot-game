extends AnimatedSprite2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.heal_health(3)
		queue_free()
