
extends Node2D

var start

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var time = OS.get_ticks_msec()
	var newseconds = (time - start) / 1000

	if newseconds > 1:
		get_node("/root/control").hide_points()

func set_points(player1, player2):
	start = OS.get_ticks_msec()
	get_node("player1").set_text(player1)
	get_node("player2").set_text(player2)