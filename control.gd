extends Node2D

var root

func _ready():
	var _root = get_tree().get_root()
	root = _root.get_child(_root.get_child_count()-1)

func shot(type, player2):
	root.get_node("ball").shot(type, player2)

func get_player(player_name):
	return root.get_node(player_name)