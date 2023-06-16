extends CharacterBody2D

var player_ref: CharacterBody2D = null
var move_speed: float = 20.0

var can_attack: bool = false
const ATTACK_COOLDOWN: float = 2.0
var attack_cooldown_timer: float = 0.0
var distance_threshold: float = 13.0

const LIFE: PackedScene = preload("res://enemys/hearth.tscn")
const AUDIO_TEMPLATE: PackedScene = preload("res://managment/audio_template.tscn")
@onready var animation: AnimationPlayer = get_node("AnimationPlayer")
@onready var texture: Sprite2D = get_node("Texture")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var health: int = 2
var can_die: bool = false

var walk_speed: float = 15.0
var walking_right: bool = true
var walk_amount: float = 0.0

func _physics_process(delta: float) -> void:
	if can_die:
		return
	
	attack_cooldown_timer -= delta
	if attack_cooldown_timer <= 0:
		can_attack = true
		$AttackArea.monitoring = true
	
	if player_ref != null:
		var direction: Vector2 = global_position.direction_to(player_ref.global_position)
		var distance: float = global_position.distance_to(player_ref.global_position)
		if is_on_floor() and can_attack:
			if distance < distance_threshold:
				spam_area_attack()
				return
			else:
				var absy = abs(player_ref.global_position.y - global_position.y)
				var absx = abs(player_ref.global_position.x - global_position.x)
				if absy > 1 and absx < 2:
					direction = global_position.direction_to(player_ref.global_position)
				else:
					direction = Vector2.ZERO
				if  player_ref.global_position.x < global_position.x:
					direction.x = -1
				else:
					direction.x = 1
				velocity = direction.normalized() * move_speed
				if !$RayFloor.is_colliding():
					velocity = Vector2.ZERO
					direction = Vector2.ZERO

	elif is_on_floor():
		walk(delta)
		
	velocity.y += gravity * delta
		
	move_and_slide()
	animate()
	update_health_bar()

func spam_area_attack() -> void:
	can_attack = false
	attack_cooldown_timer = ATTACK_COOLDOWN
	$AttackArea.monitoring = false

func animate() -> void:
	if velocity.x < 0:
		texture.flip_h = true
	elif velocity.x > 0 or walking_right:
		texture.flip_h = false
		
	if animation.current_animation == "die":
		if animation.is_playing():
			return
		else:
			animation.play("die")
		return
	if animation.current_animation == "hit":
		if animation.is_playing():
			return
		else:
			animation.play("idle")
	elif velocity.x != 0:
		animation.play("run")
	else:
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

func _on_detection_area_body_entered(body):
	if body is CharacterBody2D:
		player_ref = body

func _on_detection_area_body_exited(_body):
	player_ref = null

func _on_animation_player_animation_finished(anim_name: String) -> void:
	match anim_name:
		"die":
			var hearth = LIFE.instantiate()
			get_parent().add_child(hearth)
			hearth.global_position = global_position
			queue_free()

func walk(delta: float) -> void:
	if !$RayFloor.is_colliding():
		walking_right = !walking_right
		$RayFloor.target_position.x = -1 * $RayFloor.target_position.x
		$SecondRayFloor.target_position.x = -1 * $SecondRayFloor.target_position.x
		walk_amount = 0.0
		
	velocity.x = walk_speed if walking_right else -walk_speed
	walk_amount += walk_speed * delta
	
	if $SecondRayFloor.is_colliding():
		walking_right = !walking_right
		$RayFloor.target_position.x = -1 * $RayFloor.target_position.x
		$SecondRayFloor.target_position.x = -1 * $SecondRayFloor.target_position.x
		walk_amount = 0.0

func spawn_sfx(sfx_path: String) -> void:
	var sfx = AUDIO_TEMPLATE.instantiate()
	sfx.sfx_to_play = sfx_path
	add_child(sfx)

func update_health_bar():
	$HealthBar.value = health
	if health >= 2:
		$HealthBar.visible = false
	else:
		$HealthBar.visible = true

func _on_attack_area_body_entered(body):
	body.update_health(1)
