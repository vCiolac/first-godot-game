extends CanvasLayer

@onready var animation: AnimationPlayer = get_node('AnimationPlayer')
var scene_path: String = ""
var can_quit: bool = false
var first_boss_apears: bool = false
var instinct: bool = false

var player_health: int = 3
var player_coins: int = 0


func fade_in() -> void:
	animation.play("fade_in")
	
func _on_animation_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		if can_quit:
			get_tree().quit()
			return
			
		get_tree().change_scene_to_file(scene_path)
		save.save_file()
		animation.play("fade_out")
