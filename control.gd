extends Node2D

var root
var player1_points = 0
var player2_points = 0
var players_created = false
var next_round = false
var time_left_next_round
var next_player_to_start

var main_loop = true

var player1
var player2

const PLAYER1_POS = Vector2(150, 200)
const PLAYER2_POS = Vector2(500, 200)

func _resetPlayer():
	player1 = null
	player2 = null

func ready():
	var _root = get_tree().get_root()
	root = _root.get_child(_root.get_child_count()-1)

	set_fixed_process(true)

func _fixed_process(delta):
	if next_round:
		time_left_next_round -= delta

		if time_left_next_round <= 0:
			next_round = false

			if next_player_to_start == "player2":
				reset(true)
			else:
				reset(false)

func get_ball():
	return root.get_node("ball")

func get_player(player_name):
	return root.get_node(player_name)

func create_get_player1():
	if !player1:
		var player = load("res://player.tscn")
		player1 = player.instance()
		root.add_child(player1)
	return player1

func create_get_player2():
	if !player2:
		var player = load("res://player.tscn")
		player2 = player.instance()
		root.add_child(player2)

		player2.setPlayer2();

	return player2

func show_points(player1_points_str, player2_points_str):
	var points = load("res://points.tscn")
	var poinstaInstance = points.instance()
	root.add_child(poinstaInstance)
	poinstaInstance.set_pos(Vector2(253, 150))
	poinstaInstance.set_points(player1_points_str, player2_points_str)

func reset(player2Start):
	var player1 = create_get_player1()
	var player2 = create_get_player2()

	var ball = get_ball()

	ball.reset()

	player1.set_pos(PLAYER1_POS)
	player2.set_pos(PLAYER2_POS)

	if (!player2Start):
		var position = player1.get_player_ball_position()
		ball.set_pos(position)
		player1.catch()

	if (player2Start):
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
