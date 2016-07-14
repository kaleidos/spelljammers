extends Node2D

var root
var main_loop = true
var ia_active = false

# game
var players_created = false
var next_round = false
var time_left_next_round
var next_player_to_start

# players
var player1
var player2
var player1_config
var player2_config
var player1_points = 0
var player2_points = 0
var limit_points = 10

#TODO check real pos
const PLAYER1_POS = Vector2(150, 200)
const PLAYER2_POS = Vector2(500, 200)

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
#	#left-right 0
#	#up-down 1
#	var _root = get_tree().get_root()
#	var root2 = _root.get_child(_root.get_child_count()-1)
#	if root2.get_node("kk")!=null:
#		#main_loop = false
#		root2.get_node("kk").set_text(str(Input.get_joy_axis(0, 0)) + "----" + str(Input.get_joy_axis(0, 1)))

	if next_round:
		
		time_left_next_round -= delta
		print("time_left_next_round")
		if time_left_next_round <= 0:
			next_round = false

			control.reset_players_positions()

			if next_player_to_start == "player2":
				control.player2_start()
			else:
				control.player1_start()

	if ia_active:
		IA()
		
func get_root():
	return root

func enable_ia():
	ia_active = true

func set_scene(scene):
	root.queue_free()
	var s = ResourceLoader.load(scene)
	var newroot = s.instance()
	get_tree().get_root().add_child(newroot)

func init_scene():
	print("init")
	var _root = get_tree().get_root()
	root = _root.get_child(_root.get_child_count()-1)

	player1 = null
	player2 = null
	player1_points = 0
	player2_points = 0

func get_ball():
	return root.get_node("ball")

func get_player(player_name):
	return root.get_node(player_name)

func create_get_player1():
	if !player1:
		var player = load("res://player.tscn")
		player1 = player.instance()
		root.add_child(player1)

		player1.set_player_area("left");

	player1.set_player_config(player1_config)

	return player1

func create_get_player2():
	if !player2:
		var player = load("res://player.tscn")
		player2 = player.instance()
		root.add_child(player2)

		player2.set_player_area("right");

	player2.set_player_config(player2_config)

	return player2

func show_points(player1_points_str, player2_points_str):
	var points = load("res://points.tscn")
	var poinstaInstance = points.instance()

	root.add_child(poinstaInstance)
	
	poinstaInstance.set_pos(Vector2(267, 150))
	poinstaInstance.set_points(player1_points_str, player2_points_str)
	poinstaInstance.set_z(3)

func set_players_config(new_player1_config, new_player2_config):
	player1_config = new_player1_config
	player2_config = new_player2_config

func reset_players_positions():
	var player1 = create_get_player1()
	var player2 = create_get_player2()

	player1.set_pos(PLAYER1_POS)
	player2.set_pos(PLAYER2_POS)

func player1_start():
	var ball = get_ball()

	ball.reset()

	var position = player1.get_player_ball_position()
	ball.set_pos(position)

	player1.catch()

func player2_start():
	var ball = get_ball()

	ball.reset()

	var position = player2.get_player_ball_position()
	ball.set_pos(position)

	player2.catch()

func hide_points():
	main_loop = true
	root.get_node("points").free()

func points(p1_points, p2_points):
	if !main_loop:
		return

	var node_name = ""

	player1.stop()
	player2.stop()

	main_loop = false

	player1_points += p1_points
	player2_points += p2_points

	var player1_points_str = str(player1_points)
	var player2_points_str = str(player2_points)

	if player2_points_str.length() == 1:
		player2_points_str = "0" + player2_points_str

	if player1_points_str.length() == 1:
		player1_points_str = "0" + player1_points_str

	root.get_node("player1_points").set_text(player1_points_str)
	root.get_node("player2_points").set_text(player2_points_str)

	next_round = true
	time_left_next_round = 1

	if p1_points > 0:
		next_player_to_start = "player2"
	elif p2_points > 0:
		next_player_to_start = "player1"

	if p1_points > 2 || p2_points:
		var ball = get_ball()
		ball.deactivate()
		ball.hide()

	show_points(player1_points_str, player2_points_str)

func IA():	
	var shots_types = [Vector2(-1.5, -3), Vector2(-1.5, -1.5), Vector2(-1.5, 1.5), Vector2(-1.5, 3)	, Vector2(-1, -1)]
	var ball = get_ball()
	var ball_pos = ball.get_pos()

	if ball_pos.x > 500 && !player2.has_the_ball():
		player2.set_pos(ball_pos)
	elif player2.has_the_ball():
		var time = OS.get_ticks_msec()
		var last_catch = player2.get_last_catch_time()

		if time - last_catch > 500:
			var shot_index = randi() % shots_types.size()
			player2.shot(shots_types[shot_index], false)