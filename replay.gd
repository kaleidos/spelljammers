
extends KinematicBody2D

func _ready():
	get_node("/root/control").init_scene()
	set_fixed_process(true)
		
func _fixed_process(delta):
		if Input.is_action_pressed("player1_main") || Input.is_action_pressed("player2_main"):
			get_tree().get_root().get_node("/root/control").set_scene("res://main.tscn")
			