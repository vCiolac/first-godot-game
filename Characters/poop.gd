extends Area2D

const SPEED: int = 200
var velocity:= Vector2.ZERO

@onready var animation: AnimatedSprite2D = get_node("AnimatedSprite2D")

func _ready():
	$"life-timeout".wait_time = save.poop_time

func _physics_process(delta: float) -> void:
	position.y += SPEED * delta
	animation.play('default')
	translate(velocity)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.update_health(save.player_damage)
	queue_free()

func _on_lifetimeout_timeout():
		queue_free()
