extends Area2D

func _on_body_entered(body):
	body.update_health(100)
