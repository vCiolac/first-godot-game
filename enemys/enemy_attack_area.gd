extends Area2D

func _on_body_entered(body):
	body.update_health(1)

func _on_lifetime_timeout() -> void:
	queue_free()
