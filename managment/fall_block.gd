extends Area2D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		$AnimatedSprite2D.play('default')

func _on_animated_sprite_2d_animation_finished():
	queue_free()
