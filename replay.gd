
extends KinematicBody2D

var delay = 50

func _ready():
	get_node("/root/control").refresh_root()
	set_fixed_process(true)

func _fixed_process(delta):
	var control = get_node("/root/control")

	var players_poinsts = control.get_players_poinsts()
	var player1_points = players_poinsts.player1
	var player2_points = players_poinsts.player2

	var winner_player = "No winners"

	if player1_points > player2_points:
		winner_player = "Winner Player 1"
	elif player1_points < player2_points:
		winner_player = "Winner Player 2"

	var root = control.get_root()
	root.get_node("winner").set_text(winner_player)

	delay -= 1;
	if (Input.is_action_pressed("player1_main") || Input.is_action_pressed("player2_main")) && delay <= 0:
		get_node("/root/control").set_scene("res://main.tscn")
