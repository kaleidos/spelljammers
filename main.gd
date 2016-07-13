
extends Node2D

const player1_config = {
	"player_speed": 220,
	"dash_duration": 200,
	"dash_speed": 520,
	"time_movement_block_after_shot": 300,
	"time_automatic_shot": 2000,
	"strength": 2,
	"shot_angles": {
		"up": Vector2(1.5, -2),
		"up-middle": Vector2(1.5, -2),
		"down-middle": Vector2(1.5, 1),
		"down": Vector2(1.5, 2)
	}	
}

const player2_config = {
	"player_speed": 220,
	"dash_duration": 200,
	"dash_speed": 520,
	"time_movement_block_after_shot": 300,
	"time_automatic_shot": 2000,
	"strength": 2,
	"shot_angles": {
		"up": Vector2(1.5, -2),
		"up-middle": Vector2(1.5, -2),
		"down-middle": Vector2(1.5, 1),
		"down": Vector2(1.5, 2)
	}
}

func _ready():
	#OS.set_window_fullscreen(true)
	var control = get_node("/root/control")
	control.init_scene()
	
	control.set_players_config(player1_config, player2_config)
	control.reset_players_positions()
	control.player1_start()