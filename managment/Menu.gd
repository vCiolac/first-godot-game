extends Control

const SAVE_GAME_PATH := "user://save.dat"

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists(SAVE_GAME_PATH):
		$ButtonsList/Load.visible = true
	for button in get_tree().get_nodes_in_group('button'):
		button.pressed.connect(on_button_pressed.bind(button.name))

func on_button_pressed(imme: String) -> void:
	match imme:
		"Novo Jogo":
			transition.scene_path = 'res://managment/intro_scene.tscn'
			transition.fade_in()
		"Load":
			save.load_file()
			transition.fade_in()
		"Sair":
			transition.can_quit = true
			transition.fade_in()
	
