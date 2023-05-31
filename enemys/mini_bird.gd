extends CharacterBody2D

const ATTACK_AREA: PackedScene = preload("res://enemys/enemy_attack_area.tscn")
var OFFSET: Vector2 = Vector2(6, 9)

var player_ref: CharacterBody2D = null
@export var move_speed: float = 120.0
var distance_threshold: float = 14.0

const AUDIO_TEMPLATE: PackedScene = preload("res://managment/audio_template.tscn")
@onready var animation: AnimationPlayer = get_node("AnimationPlayer")
@onready var texture: Sprite2D = get_node("Texture")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var health: int = 2
var can_die: bool = false

var move_away: bool = true

func _physics_process(_delta: float) -> void:
	if can_die:
		return
		
	if !$RayCast.is_colliding() and player_ref == null:
		velocity.y = _delta
		position.y += 1
		move_and_slide()
		animate()
		update_health_bar()
		return

	if player_ref == null or player_ref.can_die:
		velocity = Vector2.ZERO
		animate()
		update_health_bar()
		return
		
	var direction: Vector2 = global_position.direction_to(player_ref.global_position)
	var distance: float = global_position.distance_to(player_ref.global_position)

	if move_away:
		direction = -direction  # Inverte a direção para ir para longe do jogador
		velocity = direction * move_speed
	else:
		velocity = direction * move_speed
		if distance < distance_threshold:
			animation.play('attack')
			return
		
	move_and_slide()
	animate()
	update_health_bar()

func animate() -> void:
	if velocity.x < 0:
		texture.flip_h = true
		OFFSET.x = -6
	elif velocity.x > 0:
		texture.flip_h = false
		OFFSET.x = 6
	if animation.current_animation == "die":
		return
	if animation.current_animation == "hit" or animation.current_animation == "attack":
		return
	if velocity != Vector2.ZERO:
		animation.play("move")
	elif is_on_floor():
		animation.play("idle")

func update_health(value: int) -> void:
	health -= value
	if animation.current_animation == "hit":
		return
	if health <= 0:
		can_die = true
		animation.play('die')
	else:
		animation.play('hit')
		
func spam_area_attack() -> void:
	var attack_area = ATTACK_AREA.instantiate()
	attack_area.position = OFFSET
	attack_area.scale = Vector2(0.5, 0.5)
	add_child(attack_area)

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player_ref = body

func _on_detection_area_body_exited(_body):
	player_ref = null

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"die":
			queue_free()

func spawn_sfx(sfx_path: String) -> void:
	var sfx = AUDIO_TEMPLATE.instantiate()
	sfx.sfx_to_play = sfx_path
	add_child(sfx)

func update_health_bar():
	var healthbar = $Healthbar
	healthbar.value = health
	if health >= 2:
		healthbar.visible = false
	else:
		healthbar.visible = true


func _on_fly_area_body_entered(body):
	if body.is_in_group("Player"):
		player_ref = body

func _on_fly_area_body_exited(_body):
	player_ref = null
	$FlyArea.visible = false
	move_away = false
	$DetectionArea.visible = true
	velocity = Vector2.ZERO
