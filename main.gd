
extends Node2D

const player1_config = {
	"player_speed": 160,
	"dash_duration": 190,
	"dash_speed": 350,
	"time_movement_block_after_shot": 200,
	"time_automatic_shot": 2000,
	"min_shot_angle": 0.2,
	"shots_strength": {
		"straight": [
			{"min": 0, "max": 100, "speed": 700},
			{"min": 100, "max": 300, "speed": 600},
			{"min": 300, "speed": 500}
		],
		"secondary": [
			{"min": 0, "max": 100, "speed": 270},
			{"min": 100, "max": 300, "speed": 230},
			{"min": 300, "speed": 180}
		],
		"normal_shots": [
			{"min_angle": 0.9, "max_angle": 1, "speeds": [
				{"min": 0, "max": 100, "speed": 700},
				{"min": 100, "max": 300, "speed": 600},
				{"min": 300, "speed": 500}
			]},
			{"min_angle": 0.2, "max_angle": 0.9, "speeds": [
				{"min": 0, "speed": 500}
			]}
		]
	}
}

func _ready():
	OS.set_window_fullscreen(true)
	var control = get_node("/root/control")
	control.init_scene()

	control.main_loop = true
	control.set_players_config(player1_config, player1_config)
	control.reset_players_positions()
	control.player1_start()

	#control.enable_ia()

func _on_3points( body ):
	if !body.has_method("is_ball"):
		return
	control = get_node("/root/control")

	if body.get_pos().x > 300:
		control.points(3, 0)
	else:
		control.points(0, 3)


func _on_5points( body ):
	if !body.has_method("is_ball"):
		return

	control = get_node("/root/control")

	if body.get_pos().x > 300:
		control.points(5, 0)
	else:
		control.points(0, 5)
