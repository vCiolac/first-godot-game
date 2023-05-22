extends CharacterBody2D

const LIFE: PackedScene = preload("res://enemys/hearth.tscn")
var player_ref: CharacterBody2D = null
@export var move_speed: float = 60.0
var distance_threshold: float = 30.0

const AUDIO_TEMPLATE: PackedScene = preload("res://managment/audio_template.tscn")
@onready var animation: AnimationPlayer = get_node("AnimationPlayer")
@onready var texture: Sprite2D = get_node("Texture")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var health: int = 1
var can_die: bool = false

var walk_distance: float = 20.0
var walk_speed: float = 10.0
var walking_right: bool = true
var walk_amount: float = 0.0


func _physics_process(delta: float) -> void:
	if can_die:
		return
		
	if player_ref != null:
		var direction: Vector2 = global_position.direction_to(player_ref.global_position)
		var distance: float = global_position.distance_to(player_ref.global_position)
		if distance > distance_threshold:
			direction = global_position - player_ref.global_position  # Subtrai a posição do jogador da posição do inimigo
			velocity = direction.normalized() * move_speed
		elif player_ref == null:
			direction = Vector2.ZERO
	else:
		walk(delta)

	move_and_slide()
	animate()

func animate() -> void:
	if velocity.x < 0:
		texture.flip_h = false
	elif velocity.x > 0 or walking_right:
		texture.flip_h = true
		
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
			var hearth = LIFE.instantiate()
			get_parent().add_child(hearth)
			if is_on_floor():
				hearth.global_position = global_position
				hearth.global_position.y -= 20
			else:
				hearth.global_position = global_position
			queue_free()
			
func walk(delta: float) -> void:
	if walking_right:
		velocity.x = walk_speed
	else:
		velocity.x = -walk_speed
		
	walk_amount += walk_speed * delta
	
	if walk_amount >= walk_distance:
		walking_right = !walking_right
		walk_amount = 0.0
		
	if player_ref == null:
		velocity.y = 0.0

func spawn_sfx(sfx_path: String) -> void:
	var sfx = AUDIO_TEMPLATE.instantiate()
	sfx.sfx_to_play = sfx_path
	add_child(sfx)
