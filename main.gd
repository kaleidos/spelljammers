
extends Node2D

const PLAYER1_POS = Vector2(150, 250)
const PLAYER2_POS = Vector2(500, 250)

func _ready():
	#OS.set_window_fullscreen(true)
	get_node("/root/control").reset(true)
	
	var player = load("res://player.tscn")

	var player1 = player.instance()
	add_child(player1)
	player1.set_pos(PLAYER1_POS)

	var player2 = player.instance()
	add_child(player2)
	player2.setPlayer2();
	player2.set_pos(PLAYER2_POS)
