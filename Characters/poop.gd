extends Area2D

const SPEED: int = 200
var velocity:= Vector2.ZERO
var direction := 1

@onready var animation: AnimatedSprite2D = get_node("AnimatedSprite2D")

func _ready() -> void:
	$Poop.play()

func set_dir (dir):
	direction = dir
	if direction == 1:
		animation.flip_h = false
	else:
		animation.flip_v = true

func _physics_process(delta: float) -> void:
	position.y += SPEED * delta * direction
	animation.play('default')
	translate(velocity)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.update_health(1)
	queue_free()
