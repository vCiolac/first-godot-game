extends CharacterBody2D

const ATTACK_AREA: PackedScene = preload("res://enemys/enemy_attack_area.tscn")
const EXPLODE: PackedScene = preload("res://enemys/explodes.tscn")
var distance_threshold: float = 35.0
@export var move_speed: float = 80.0
var player = null
var not_move:bool = false

func _physics_process(delta: float) -> void:
	if not_move:
		return
	if player != null:
		var distance: float = global_position.distance_to(player.global_position)
		if distance < distance_threshold:
				if $AnimationPlayer.current_animation != "fly_attack":
					$AnimationPlayer.play("fly_attack")
					not_move = true
	velocity.x = delta + move_speed
	move_and_slide() 
	animate()
	
func spam_attack():
	var attack_area = ATTACK_AREA.instantiate()
	attack_area.position = Vector2(10, 0)
	add_child(attack_area)
	var explode = EXPLODE.instantiate()
	explode.position = Vector2(0, 0)
	add_child(explode)
	
func animate() -> void:
	if $AnimationPlayer.current_animation == "fly_attack":
		return
	if velocity.x > 1:
		$AnimationPlayer.play("fly")
	
func die_queue():
	queue_free()

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body

func update_health():
	pass
	
func donot_move() -> void:
	not_move = true
