extends Node2D

@onready var interface : CanvasLayer = $Interface
@onready var health_label : Label = $Interface/Health
@onready var coins_label : Label = $Interface/Coins

@export var next_transition_scene: String
@export var current_level_scene: String = "res://managment/level1.tscn"

func _ready() -> void:
	transition.scene_path = current_level_scene
	update_health(transition.player_health)
	get_coins(transition.player_coins)

func update_health(new_health: int) -> void:
	health_label.text = 'Hp: ' + str(new_health)
	
func get_coins(new_coins: int) -> void:
	coins_label.text = "Coins: " + str(new_coins)

func _on_portal_body_entered(_body):
	transition.scene_path = next_transition_scene
	transition.fade_in(true)
