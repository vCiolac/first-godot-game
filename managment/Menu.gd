extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in get_tree().get_nodes_in_group('button'):
		button.pressed.connect(on_button_pressed.bind(button.name))

func on_button_pressed(imme: String) -> void:
	match imme:
		"Novo Jogo":
			transition.scene_path = 'res://managment/intro_scene.tscn'
			transition.fade_in()
		"Sair":
			transition.can_quit = true
			transition.fade_in()
	
