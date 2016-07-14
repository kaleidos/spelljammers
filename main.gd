
extends Node2D

const player1_config = {
	"player_speed": 220,
	"dash_duration": 200,
	"dash_speed": 520,
	"time_movement_block_after_shot": 300,
	"time_automatic_shot": 2000,
	"shot_angles": {
		"up": Vector2(1.5, -4),
		"up-middle": Vector2(1.5, -2),
		"down-middle": Vector2(1.5, 1),
		"down": Vector2(1.5, 4)
	},
	"shots_strength": {
		"normal_shots": [
			{"min": 0, "max": 100, "speed": 700},
			{"min": 100, "max": 300, "speed": 500},
			{"min": 300, "speed": 200}
		],
		"angle_shots": [
			{"min": 0, "speed": 700, "angles": ["up", "down"]},
			{"min": 0, "speed": 600, "angles": ["up-middle", "down-middle"]}
		]
	}
}

const player2_config = {
	"player_speed": 220,
	"dash_duration": 200,
	"dash_speed": 520,
	"time_movement_block_after_shot": 300,
	"time_automatic_shot": 2000,
	"shot_angles": {
		"up": Vector2(1.5, -4),
		"up-middle": Vector2(1.5, -2),
		"down-middle": Vector2(1.5, 1),
		"down": Vector2(1.5, 4)
	},
	"shots_strength": {
		"normal_shots": [
			{"min": 0, "max": 100, "speed": 700},
			{"min": 100, "max": 300, "speed": 500},
			{"min": 300, "speed": 200}
		],
		"angle_shots": [
			{"min": 0, "speed": 700, "angles": ["up", "down"]},
			{"min": 0, "speed": 600, "angles": ["up-middle", "down-middle"]}
		]
	}
}

func _ready():
	#OS.set_window_fullscreen(true)
	var control = get_node("/root/control")
	control.init_scene()

	control.set_players_config(player1_config, player2_config)
	control.reset_players_positions()
	control.player1_start()