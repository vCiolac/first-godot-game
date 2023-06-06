extends Node

const SAVE_GAME_PATH := "user://save.dat"

var player_speed : float = 150.0
var player_jump_velocity : float = -120.0
var player_double_jump_velocity : float = -160.0
var player_triple_jump_velocity : float = -220.0
var player_damage: int = 1
var poop_time: float = 0.3

func save_file():
	var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
	var player_data = create_player_data()
	file.store_var(player_data)
	
func load_file():
	var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_GAME_PATH):
		var loaded_player_data = file.get_var()
		transition.player_health = loaded_player_data.HEALTH
		transition.player_coins = loaded_player_data.COINS
		transition.scene_path = loaded_player_data.SCENE_FILE
		save.player_damage = loaded_player_data.DAMAGE
		save.player_speed = loaded_player_data.SPEED
		save.player_jump_velocity = loaded_player_data.JUMP
		save.player_double_jump_velocity = loaded_player_data.DOUBLEJUMP
		save.player_triple_jump_velocity = loaded_player_data.TRIPLEJUMP
		save.poop_time = loaded_player_data.POOP_DISTANCE
		
func create_player_data():
	var player_dict = {
		"HEALTH" : transition.player_health,
		"COINS" : transition.player_coins,
		"SCENE_FILE" : transition.scene_path,
		"DAMAGE" : save.player_damage,
		"SPEED" : save.player_speed,
		"JUMP" : save.player_jump_velocity,
		"DOUBLEJUMP" : save.player_double_jump_velocity,
		"TRIPLEJUMP" : save.player_triple_jump_velocity,
		"POOP_DISTANCE" : save.poop_time,
	}
	return player_dict
