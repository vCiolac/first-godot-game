extends Node2D

@onready var interface : CanvasLayer = $Interface
@onready var health_bar : TextureProgressBar = $Interface/HpBar
@onready var mana_bar : TextureProgressBar = $Interface/MpBar
@onready var coins_label : Label = $Interface/Coins
@onready var health_value : Label = $Interface/HpValue

@export var next_transition_scene: String
@export var current_level_scene: String = "res://managment/level-2.tscn"

var second_anim: bool = false
var third_anim: bool = false

func _ready() -> void:
	transition.scene_path = current_level_scene
	update_health(transition.player_health)
	get_coins(transition.player_coins)
	transition.player_is_hurt = true
	$Interface.visible = false

func update_health(new_health: int) -> void:
	if transition.player_health > health_bar.max_value:
		health_bar.max_value = transition.player_health
	health_bar.value = new_health
	health_value.text = str(transition.player_health) + ' / ' + str(health_bar.max_value)

func get_coins(new_coins: int) -> void:
	coins_label.text = str(new_coins)

func _on_portal_body_entered(body):
	if body.is_in_group("Player"):
		$Player.visible = false
		$Player.position = Vector2(1047, 540)
		$Portal/AnimationPlayer.play("closing")
		transition.scene_path = next_transition_scene
		transition.fade_in()


func _on_intro_anim_animation_finished(anim_name):
	match anim_name:
		'falling':
			$Interface.visible = true
			$BackgroundMusic.play()

func second_anim_pass() -> void:
	second_anim = true

func third_anim_pass() -> void:
	third_anim = true

func _on_toupeira_area_body_entered(body):
	if body.is_in_group("Player"):
		if $IntroAnim.current_animation == "falling":
			return
		if second_anim == false:
			$IntroAnim.play('second')
		if second_anim == true:
			$IntroAnim.play('third')
		if third_anim == true:
			$IntroAnim.play('fourth')
