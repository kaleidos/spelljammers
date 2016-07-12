
extends Node2D

func _ready():
	#OS.set_window_fullscreen(true)

	get_node("/root/control").reset(true)
