extends Node2D

var root
var player1_points = 0
var player2_points = 0
var players_created = false

var main_loop = true

var player1
var player2

const PLAYER1_POS = Vector2(150, 200)
const PLAYER2_POS = Vector2(500, 200)

func _ready():
	var _root = get_tree().get_root()
	root = _root.get_child(_root.get_child_count()-1)

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
	print(root)
	var ball = root.get_node("ball")

	ball.deactivate()

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

	if p1_points > 0:
		reset(true)
	elif p2_points > 0:
		reset(false)

	show_points(player1_points_str, player2_points_str)
