
extends KinematicBody2D

var delay = 50

func _ready():
	get_node("/root/control").init_scene()
	set_fixed_process(true)
		
func _fixed_process(delta):

	var player1_points = get_node("/root/control").player1_points
	var player2_points = get_node("/root/control").player2_points
	
	var winner_player = "No winners"
	
	if player1_points > player2_points: 
		winner_player = "Winner Player 1"
	elif player1_points < player2_points:
		winner_player = "Winner Player 2"
		
	var _root = get_tree().get_root()
	var root = _root.get_child(_root.get_child_count()-1)
	root.get_node("winner").set_text(winner_player)
	
	delay -= 1;
	if ( Input.is_action_pressed("player1_main") || Input.is_action_pressed("player2_main") ) && delay <= 0:
		print("delay")
		get_node("/root/control").set_scene("res://main.tscn")
			