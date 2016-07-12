extends Node2D

var root
var player1_points = 0
var player2_points = 0
var players_created = false

var player1
var player2

const PLAYER1_POS = Vector2(150, 200)
const PLAYER2_POS = Vector2(500, 200)

func _ready():
	var _root = get_tree().get_root()
	root = _root.get_child(_root.get_child_count()-1)

func shot(type, player2):
	root.get_node("ball").shot(type, player2)

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

func reset(player2Start):
	var player1 = create_get_player1()
	var player2 = create_get_player2()

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

func points(number, player2loose):
	if player2loose:
		player1_points += number
		var points = str(player1_points)

		if points.length() == 1:
			points = "0" + points

		root.get_node("player1_points").set_text(points)
		reset(true)
	else:
		player2_points += number
		var points = str(player2_points)

		if points.length() == 1:
			points = "0" + points

		root.get_node("player2_points").set_text(points)

		reset(false)
