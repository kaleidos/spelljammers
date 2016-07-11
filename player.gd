
extends KinematicBody2D

var movement = Vector2()
var activate = true

const PLAYER_SPEED = 220

func _ready():
	set_fixed_process(true)

func deactivate():
	activate = false

func _fixed_process(delta):
	var control = get_node("/root/control")

	# shot
	if Input.is_action_pressed("main") && !activate:
		if Input.is_action_pressed("game_right") && Input.is_action_pressed("game_up"):
			control.shot("right-up")
		elif Input.is_action_pressed("game_right") && Input.is_action_pressed("game_down"):
			control.shot("right-down")
		elif Input.is_action_pressed("game_up"):
			control.shot("up")
		elif Input.is_action_pressed("game_down"):
			control.shot("down")
		elif Input.is_action_pressed("game_right"):
			control.shot("right")
		elif Input.is_action_pressed("game_left"):
			control.shot("left")
		else:
			control.shot("right")


		activate = true

	if !activate:
		return

	var initialX = movement.x
	var initialY = movement.y
	var boost_speed = 0

	# move
	if Input.is_action_pressed("game_right"):
		movement.x = PLAYER_SPEED + boost_speed
	if Input.is_action_pressed("game_left"):
		movement.x = -(PLAYER_SPEED + boost_speed)
	if Input.is_action_pressed("game_up"):
		movement.y = -(PLAYER_SPEED + boost_speed)
	if Input.is_action_pressed("game_down"):
		movement.y = PLAYER_SPEED + boost_speed

	# the player doens't move
	if initialX == movement.x && initialY == movement.y:
		movement.x = 0
		movement.y = 0

	var motion = movement * delta
	move(motion)

