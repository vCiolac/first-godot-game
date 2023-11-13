extends CanvasLayer

@onready var animation: AnimationPlayer = get_node('AnimationPlayer')
var scene_path: String = ""
var can_quit: bool = false
var first_boss_apears: bool = false
var instinct: bool = false

var player_health: int = 3
var player_coins: int = 0
var coins_collected_during_phase: int = 0
var player_is_hurt: bool = false
var third_level_anim_falling: bool = false

var second_anim: bool = false
var third_anim: bool = false
var fourth_anim: bool = false

func fade_in() -> void:
	animation.play("fade_in")
	
func _on_animation_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		if can_quit:
			get_tree().quit()
			return
		
		transition.player_coins += transition.coins_collected_during_phase
		transition.coins_collected_during_phase = 0
		get_tree().change_scene_to_file(scene_path)
		save.save_file()
		animation.play("fade_out")
