extends Node2D

@onready var interface : CanvasLayer = $Interface
@onready var health_bar : TextureProgressBar = $Interface/HpBar
@onready var mana_bar : TextureProgressBar = $Interface/MpBar
@onready var coins_label : Label = $Interface/Coins
@onready var health_value : Label = $Interface/HpValue
@onready var joystick : CanvasLayer = $Interface/UI
@onready var bg_audio: AudioStreamPlayer = $Bg

@export var next_transition_scene: String
@export var current_level_scene: String = "res://managment/level_2.tscn"

const PLAT := preload("res://managment/platform.tscn")
const HEARTH := preload("res://enemys/hearth.tscn")
const CROW := preload("res://enemys/crow_explodes.tscn")
var hearth_increment = 1

func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_text_clear_carets_and_selection"):
		if has_node("BossCutScene"):
			if $BossCutScene.current_animation == "default":
				_on_boss_cut_scene_animation_finished("default")
				$Player.can_i_move(true)
				platformer_create()
				start_bg()
		else:
			pass
		
func _ready() -> void:
	$Storm/TimerThunder.stop()
	$Storm2/TimerThunder.stop()
	$Cloud3.emitting = false
	transition.scene_path = current_level_scene
	update_health(transition.player_health)
	get_coins(transition.player_coins)
	
	if transition.first_boss_apears == false:
		$BossCutScene.play("default")
	else:
		platformer_create()
		start_bg()
		continues()
		
func update_health(new_health: int) -> void:
	if transition.player_health > health_bar.max_value:
		health_bar.max_value = transition.player_health
	health_bar.value = new_health
	health_value.text = str(transition.player_health) + ' / ' + str(health_bar.max_value)

func get_coins(new_coins: int) -> void:
	coins_label.text = str(new_coins)
	
func platformer_create():
	var x_position = randf_range(150, 1800)
	var x2_position = randf_range(1850, 2900)
	var y_position =  randf_range(0, -150)
	var y_hearth_position =  randf_range(25, 630)
	
	var plat = PLAT.instantiate()
	add_child(plat)
	var plat2 = PLAT.instantiate()
	add_child(plat2)
	if plat:
		plat.position = Vector2(x_position, y_position)
	if plat2:
		plat2.position = Vector2(x2_position, y_position)
		
	if randi() % 6 == 0:
		var hearth = HEARTH.instantiate()
		add_child(hearth)
		if hearth:
			hearth.position = Vector2(x_position, y_hearth_position)
			hearth_increment += 1
			hearth.position.y += hearth_increment
			
	$PlatformTimer.start()

func crow_create():
	if randi() % 4 == 0:
		var crow = CROW.instantiate()
		add_child(crow)
		crow.position = Vector2(0, randf_range(10, 630))
	$CrowTimer.start()

func _on_platform_timer_timeout():
	platformer_create()

func _on_crow_timer_timeout():
	crow_create()

func start_bg() -> void:
	bg_audio.play()
	
func first_crows() -> void:
	var crow2 = CROW.instantiate()
	crow2.position = Vector2(310, 165)
	add_child(crow2)
	var crow2_animation_player = crow2.get_node("AnimationPlayer")
	crow2_animation_player.play("fly_attack")
	
func second_crows() -> void:
	var crow = CROW.instantiate()
	crow.position = Vector2(273, 134)
	add_child(crow)
	var crow_animation_player = crow.get_node("AnimationPlayer")
	crow_animation_player.play("fly_attack")

func _on_kill_birds_wall_body_entered(body):
	body.queue_free()

func _on_boss_cut_scene_animation_finished(_anim_name):
	$Interface.visible = true
	joystick.visible = true
	$Cloud3.emitting = true
	$Cloud3.visible = true
	$Storm.visible = true
	$Storm2.visible = true
	$CrowTimer.start()
	$Storm/TimerThunder.start()
	$Storm2/TimerThunder.start()
	$BossCutScene.queue_free()
	transition.first_boss_apears = true

func continues():
	$Interface.visible = true
	joystick.visible = true
	$Cloud3.emitting = true
	$Cloud3.visible = true
	$Storm.visible = true
	$Storm2.visible = true
	await get_tree().create_timer(5).timeout
	$CrowTimer.start()
	$Storm/TimerThunder.start()
	$Storm2/TimerThunder.start()
	$BossCutScene.queue_free()

func do_flash() -> void:
	$DoneCutScene/Flash.visible = true
	$DoneCutScene/Flash.play()
	
func _on_donecut_body_entered(body):
	if body.is_in_group("Player"):
		$Player.can_i_move(false)
		$KillBirdsWall.position = Vector2(2838, 241)
		$CrowTimer.stop()
		$PlatformTimer.stop()
		$DoneCutScene.play("done")
	
func pass_level():
	transition.scene_path = next_transition_scene
	transition.fade_in()

