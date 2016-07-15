
extends KinematicBody2D

var delay = 50

func _ready():
	get_node("/root/control").refresh_root()
	set_fixed_process(true)

func _fixed_process(delta):
	var control = get_node("/root/control")
	var root = control.get_root()
	
	var players_poinsts = control.get_players_poinsts()
	var player1_points = players_poinsts.player1
	var player2_points = players_poinsts.player2
	var looser_player = ""

	var winner_player = "No winners"
	var winner_points = str(player1_points) + " points"

	if player1_points > player2_points:
		winner_player = "Winner Player 1"
		winner_points = str(player1_points) + " points"
		looser_player = "Player 2 loose! - " + str(player2_points) + " points"
	elif player1_points < player2_points:
		winner_player = "Winner Player 2"
		winner_points = str(player2_points) + " points"
		looser_player = "Player 1 loose! - " + str(player1_points) + " points"

	root.get_node("points").set_text(winner_points)
	root.get_node("winner").set_text(winner_player)
	root.get_node("looser").set_text(looser_player)

	delay -= 1;
	if (Input.is_action_pressed("player1_main") || Input.is_action_pressed("player2_main")) && delay <= 0:
		get_node("/root/control").set_scene("res://main.tscn")
