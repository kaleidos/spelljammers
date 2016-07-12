
extends Node2D

const PLAYER1_POS = Vector2(150, 250)
const PLAYER2_POS = Vector2(500, 250)

func _ready():
	#OS.set_window_fullscreen(true)
	get_node("/root/control").reset(true)