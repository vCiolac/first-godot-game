extends Area2D

func _on_body_entered(body):
	body.get_coins(1)
	queue_free()

func _on_lifetime_timeout() -> void:
	queue_free()
