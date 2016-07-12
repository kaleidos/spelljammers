
extends KinematicBody2D

# member variables here, example:
var currentScene = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)
	
		
func _fixed_process(delta):
		if Input.is_action_pressed("player1_main") || Input.is_action_pressed("player2_main"):
			setScene("res://main.tscn")
			
func setScene(scene):
	#clean up the current scene
	currentScene.queue_free()
	#load the file passed in as the param "scene"
	var s = ResourceLoader.load(scene)
	#create an instance of our scene
	currentScene = s.instance()
	#add scene to root
	get_tree().get_root().add_child(currentScene)