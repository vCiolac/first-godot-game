extends Node2D

@onready var interface : CanvasLayer = $Interface
@onready var joystick : CanvasLayer = $Interface/UI
@onready var health_bar : TextureProgressBar = $Interface/HpBar
@onready var mana_bar : TextureProgressBar = $Interface/MpBar
@onready var coins_label : Label = $Interface/Coins
@onready var health_value : Label = $Interface/HpValue

@export var next_transition_scene: String
@export var current_level_scene: String = "res://managment/level-2.tscn"

func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_text_clear_carets_and_selection"):
		if has_node("IntroAnim"):
			if $IntroAnim.current_animation == "falling":
				jump_anim()
		else:
			pass
	if transition.third_level_anim_falling == true:
		$Player.can_i_move(true)

func jump_anim() -> void:
	$IntroAnim.stop()
	$Interface.visible = true
	joystick.visible = true
	$Player.can_i_move(true)
	$Player.position = Vector2 (16, 556)
	$Player.rotation_degrees = 0
	if transition.second_anim == false:
		$IntroAnim/Toupeira.position = Vector2(423, 517)
	if transition.second_anim:
		$IntroAnim/Toupeira.position = Vector2(824, 552)
	if transition.third_anim:
		$IntroAnim/Toupeira.position = Vector2(1919,601)
	if transition.fourth_anim:
		$IntroAnim/Toupeira.position = Vector2(2742,534)
	$IntroAnim/Toupeira.modulate = '#ffffff'
	$BackgroundMusic.play()
	transition.third_level_anim_falling = true

func _ready() -> void:
	transition.scene_path = current_level_scene
	update_health(transition.player_health)
	get_coins(transition.player_coins)
	transition.player_is_hurt = true
	$Interface.visible = false
	joystick.visible = false
	if transition.third_level_anim_falling == true:
		jump_anim()

func update_health(new_health: int) -> void:
	if transition.player_health > health_bar.max_value:
		health_bar.max_value = transition.player_health
	health_bar.value = new_health
	health_value.text = str(transition.player_health) + ' / ' + str(health_bar.max_value)

func get_coins(new_coins: int) -> void:
	coins_label.text = str(new_coins)

func _on_intro_anim_animation_finished(anim_name):
	match anim_name:
		'falling':
			$Interface.visible = true
			joystick.visible = true
			$BackgroundMusic.play()
			transition.third_level_anim_falling = true
		'five':
			$IntroAnim.queue_free()

func second_anim_pass() -> void:
	transition.second_anim = true

func third_anim_pass() -> void:
	transition.third_anim = true
	
func fourth_anim_pass() -> void:
	transition.fourth_anim = true

func _on_toupeira_area_body_entered(body):
	if body.is_in_group("Player"):
		if $IntroAnim.current_animation == "falling":
			return
		if transition.second_anim == false:
			$IntroAnim.play('second')
		if transition.second_anim == true:
			$IntroAnim.play('third')
		if transition.third_anim == true:
			$IntroAnim.play('fourth')
		if transition.fourth_anim == true:
			$IntroAnim.play('five')


func _on_to_cave_body_entered(body):
	if body.is_in_group("Player"):
		$Player.visible = false
		$Player.position = Vector2(1047, 540)
		transition.scene_path = next_transition_scene
		transition.fade_in()
