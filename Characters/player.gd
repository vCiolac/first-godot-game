extends CharacterBody2D

const POOP := preload("res://Characters/poop.tscn")
var attack_instance: Node = null

var speed = save.player_speed
var jump_velocity = save.player_jump_velocity
var double_jump_velocity = save.player_double_jump_velocity
var triple_jump_velocity = save.player_triple_jump_velocity

var can_attack = true
var can_move: bool = true
var can_die: bool = false

const AUDIO_TEMPLATE: PackedScene = preload("res://managment/audio_template.tscn")
@onready var dust : GPUParticles2D = get_node("Dust")
@onready var animation : AnimationPlayer = get_node("AnimationPlayer")
@onready var texture: Sprite2D = get_node("Texture")
@onready var colli: CollisionShape2D = get_node("CollisionShape2D")
@onready var colli_fly: CollisionShape2D = get_node("Collision-fly")
@onready var actionable_finder: Area2D = $Direction/ActionableFinder

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jump : bool = false
var has_triple_jump : bool = false
var animation_locked : bool = false
var was_in_air : bool = false
var direction : Vector2 = Vector2.ZERO

func _ready() -> void:
	if transition.player_health <= 0:
		transition.player_health = 3
		return

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return

func _physics_process(delta):
	if can_die or can_move == false:
		return
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")
	move(delta)
	attack_handler()
	
func move(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		has_double_jump = false
		has_triple_jump = false
		
		if was_in_air == true:
			land()
			
		was_in_air = false

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			$Fly.play()
			jump()
		elif not has_double_jump and !transition.player_is_hurt:
			$Fly.play()
			velocity.y = double_jump_velocity
			has_double_jump = true
		elif not has_triple_jump and !transition.player_is_hurt:
			$Fly.play()
			velocity.y = triple_jump_velocity
			has_triple_jump = true

	# Handle Movement.
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()
	update_facing_direction()
	
func update_animation():
	if can_move == false:
		return
	if animation.current_animation == "hit":
		return
	if is_on_floor():
		if direction.x != 0:
			animation.play("run")
			dust.emitting = false
		else:
			animation.play("idle")
			dust.emitting = false
	else:
		animation.play("fly")
		dust.emitting = true


func update_facing_direction():
	if animation.current_animation == "hit":
		return
	if direction.x > 0:
		texture.flip_h = false 
		$CollisionShape2D.position.x = -3
		$"Collision-fly".position.x = -3
		$"Poop-position".position.x = -4
		$Direction.rotation = 0
		$Dust.position.x = -8
	elif direction.x < 0:
		texture.flip_h = true
		$Dust.position.x = 8
		$Direction.rotation = -160
		$CollisionShape2D.position.x = 3
		$"Collision-fly".position.x = 3
		$"Poop-position".position.x = 4

func jump():
	if animation.current_animation == "hit":
		return
	if is_on_floor():
		colli_fly.set_disabled(false)
		velocity.y = jump_velocity
		animation.play("fly")
	else:
		velocity.y = double_jump_velocity
		if not has_double_jump:
			has_double_jump = true
		else:
			has_triple_jump = true
	animation_locked = true

func land():
	if animation.current_animation == "hit":
		return
	colli_fly.set_disabled(true)
	animation.play("idle")
	animation_locked = true

func _on_animation_player_animation_finished(anim_name):
	if(["fly", "idle", "run", "hit"].has(animation)):
		animation_locked = false
	match anim_name:
		'die':
			transition.coins_collected_during_phase = 0
			transition.player_health = 0
			get_tree().reload_current_scene()

func attack_handler():
	if Input.is_action_just_pressed("attack") and can_attack:
		if attack_instance == null or attack_instance.has_node("AnimationPlayer") and !attack_instance.get_node("AnimationPlayer").is_playing():
			attack_instance = POOP.instantiate()
			add_child(attack_instance)
			attack_instance.position = $"Poop-position".position
			can_attack = false
			$Timer_attack.start()
			$Poop.play()

func update_health(value: int) -> void:
	transition.player_health -= value
	get_tree().call_group("level", "update_health", transition.player_health)
	if animation.current_animation == "hit":
		return
	if transition.player_health <= 0:
		can_die = true
		animation.play('die')
		return
	animation.play('hit')
	
func heal_health(value: int) -> void:
	transition.player_health += value
	get_tree().call_group("level", "update_health", transition.player_health)
	$Heal.play()
	
func get_coins(value: int) -> void:
	transition.coins_collected_during_phase += value
	get_tree().call_group("level", "get_coins", transition.player_coins + transition.coins_collected_during_phase)
	$Coin.play()
	
func spawn_sfx(sfx_path: String) -> void:
	var sfx = AUDIO_TEMPLATE.instantiate()
	sfx.sfx_to_play = sfx_path
	add_child(sfx)

func _on_timer_attack_timeout():
	can_attack = true

func _on_instinct_area_entered(_area):
	transition.instinct = true

func _on_instinct_area_exited(_area):
	transition.instinct = false

func can_i_move(p: bool) -> void:
	if p:
		can_move = true
	else:
		can_move = false
