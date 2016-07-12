
extends Node2D

const PLAYER1_POS = Vector2(150, 200)
const PLAYER2_POS = Vector2(500, 200)

func _ready():
	#OS.set_window_fullscreen(true)

	var player = load("res://player.scn")

	var player1 = player.instance()
	add_child(player1)
	player1.set_pos(PLAYER1_POS)

	var player2 = player.instance()
	add_child(player2)
	player2.setPlayer2();
	player2.set_pos(PLAYER2_POS)

