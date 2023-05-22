extends CharacterBody2D

const ATTACK_AREA: PackedScene = preload("res://enemys/enemy_attack_area.tscn")
const COIN: PackedScene = preload("res://enemys/coin.tscn")
var OFFSET: Vector2 = Vector2(28, 0)

var player_ref: CharacterBody2D = null
@export var move_speed: float = 80.0
var distance_threshold: float = 30.0

const AUDIO_TEMPLATE: PackedScene = preload("res://managment/audio_template.tscn")
@onready var animation: AnimationPlayer = get_node("AnimationPlayer")
@onready var texture: Sprite2D = get_node("Texture")
@onready var colli: CollisionShape2D = get_node("Collision")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@export var health: int = 5
var can_die: bool = false

var walk_distance: float = 100.0
var walk_speed: float = 10.0
var walking_right: bool = true
var walk_amount: float = 0.0


func _physics_process(delta: float) -> void:
	if can_die:
		return
		
	if player_ref != null:
		var direction: Vector2 = global_position.direction_to(player_ref.global_position)
		var distance: float = global_position.distance_to(player_ref.global_position)
		if is_on_floor():
			if distance < distance_threshold:
				if animation.current_animation != "attack":
					animation.play('attack')
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
				if !$Ray_floor.is_colliding():
					velocity = Vector2.ZERO
					direction = Vector2.ZERO
					if  player_ref.global_position.x < global_position.x:
						$Ray_floor.target_position.x = -16
						walking_right = false
					else:
						$Ray_floor.target_position.x = 30
						walking_right = true
	elif is_on_floor():
		walk(delta)
		
	velocity.y += gravity * delta
		
	move_and_slide()
	animate()

func spam_area_attack() -> void:
	var attack_area = ATTACK_AREA.instantiate()
	attack_area.position = OFFSET
	add_child(attack_area)

func animate() -> void:
	if velocity.x < 0:
		texture.flip_h = false
		OFFSET.x = -14
		$Ray_floor.target_position.x = -16
		colli.position.x = 6
	elif velocity.x > 0 or walking_right:
		texture.flip_h = true
		colli.position.x = -3
		$Ray_floor.target_position.x = 30
		OFFSET.x = 20
		
	if animation.current_animation == "hit":
		return
	
	if velocity.x != 0:
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
			var coin = COIN.instantiate()
			get_parent().add_child(coin)
			coin.global_position = global_position
			queue_free()

func walk(delta: float) -> void:
	if !$Ray_floor.is_colliding():
		if walking_right:
			walking_right = false
		else:
			walking_right = true
	if walking_right:
		velocity.x = walk_speed
	else:
		velocity.x = -walk_speed
		
	walk_amount += walk_speed * delta
	
	if walk_amount >= walk_distance:
		walking_right = !walking_right
		walk_amount = 0.0

func spawn_sfx(sfx_path: String) -> void:
	var sfx = AUDIO_TEMPLATE.instantiate()
	sfx.sfx_to_play = sfx_path
	add_child(sfx)
