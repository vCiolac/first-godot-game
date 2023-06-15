extends Node2D

@onready var interface : CanvasLayer = $Interface
@onready var health_bar : TextureProgressBar = $Interface/HpBar
@onready var mana_bar : TextureProgressBar = $Interface/MpBar
@onready var coins_label : Label = $Interface/Coins
@onready var health_value : Label = $Interface/HpValue

const COIN: PackedScene = preload("res://enemys/coin.tscn")
const BEETLE: PackedScene = preload("res://enemys/beetle.tscn")

@export var next_transition_scene: String
@export var current_level_scene: String = "res://managment/level1.tscn"

func _ready() -> void:
	$Portal.position = Vector2(1200,261)
	transition.scene_path = current_level_scene
	update_health(transition.player_health)
	get_coins(transition.player_coins + transition.coins_collected_during_phase)
	
func _process(_delta):
	if State.first_talk == "talked":
		$Portal.position = Vector2(623, 248)
	if State.has_secret == "taked":
		State.has_secret = "getcoins"	
		for i in range(5):
			var coin = COIN.instantiate()
			get_parent().add_child(coin)
			var coinOffsetX = 41
			var coinOffsetY = 23
			coin.global_position.x = $IntroNPC.global_position.x + coinOffsetX * i
			coin.global_position.y = $IntroNPC.global_position.y + coinOffsetY
	if State.call_bug == "call":
		$summon.play()
		var bug1 = BEETLE.instantiate()
		get_parent().add_child(bug1)
		bug1.position.x =  348
		bug1.position.y =  586
		var bug = BEETLE.instantiate()
		get_parent().add_child(bug)
		bug.position.x = 114
		bug.position.y = 423
		State.call_bug = "called"

func update_health(new_health: int) -> void:
	if transition.player_health > health_bar.max_value:
		health_bar.max_value = transition.player_health
	health_bar.value = new_health
	health_value.text = str(transition.player_health) + ' / ' + str(health_bar.max_value)

func get_coins(new_coins: int) -> void:
	coins_label.text = str(new_coins)

func _on_invisible_wall_body_entered(body):
	if body is CharacterBody2D:
		body.position = Vector2(75, 512)

func _on_portal_body_entered(body):
	if body.is_in_group("Player"):
		$Player.visible = false
		$Player.position = $Portal.position
		$Portal/AnimationPlayer.play("closing")
		transition.scene_path = next_transition_scene
		transition.fade_in()
