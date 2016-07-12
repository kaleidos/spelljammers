
extends KinematicBody2D

# member variables here, example:

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	
		
func _fixed_process(delta):
		if Input.is_action_pressed("player1_main") || Input.is_action_pressed("player2_main"):
			get_tree().get_root().get_node("/root/init")._setScene("res://main.tscn")
			