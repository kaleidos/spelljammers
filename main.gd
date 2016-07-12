
extends Node2D

const PLAYER1_POS = Vector2(150, 250)
const PLAYER2_POS = Vector2(500, 250)
var currentScene = null

func _ready():
	#OS.set_window_fullscreen(true)
	get_node("/root/control").reset(true)
	
	#on load set the current scene to the last scene available
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)
	
	var player = load("res://player.tscn")

	var player1 = player.instance()
	add_child(player1)
	player1.set_pos(PLAYER1_POS)

	var player2 = player.instance()
	add_child(player2)
	player2.setPlayer2();
	player2.set_pos(PLAYER2_POS)

func setScene(scene):
	#clean up the current scene
	currentScene.queue_free()
	#load the file passed in as the param "scene"
	var s = ResourceLoader.load(scene)
	#create an instance of our scene
	currentScene = s.instance()
	#add scene to root
	get_tree().get_root().add_child(currentScene)
