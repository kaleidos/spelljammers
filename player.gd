
extends KinematicBody2D

var movement = Vector2()
var activate = true
var player2 = false

const PLAYER_SPEED = 220

func _ready():
	set_fixed_process(true)

func deactivate():
	activate = false

func catch():
	deactivate()

func is_player():
	return true

func setPlayer2():
	player2 = true
	get_node("Sprite").set_scale(Vector2(-1, 1))

func get_player_event(event):
	if player2:
		return "player2_" + event
	else:
		return "player1_" + event

func get_player_ball_position():
	var pos = get_pos()

	if player2:
		pos.x -= 30
		return pos
	else:
		pos.x += 30
		return pos

func _fixed_process(delta):
	var control = get_node("/root/control")

	# shot
	if player2:
		if Input.is_action_pressed(get_player_event("main")) && !activate:
			if Input.is_action_pressed(get_player_event("left")) && Input.is_action_pressed(get_player_event("up")):
				control.shot("left-up", true)
			elif Input.is_action_pressed(get_player_event("left")) && Input.is_action_pressed(get_player_event("down")):
				control.shot("left-down", true)
			elif Input.is_action_pressed(get_player_event("up")):
				control.shot("up", true)
			elif Input.is_action_pressed(get_player_event("down")):
				control.shot("down", true)
			else:
				control.shot("left", true)

			activate = true
	else:
		if Input.is_action_pressed(get_player_event("main")) && !activate:
			if Input.is_action_pressed(get_player_event("right")) && Input.is_action_pressed(get_player_event("up")):
				control.shot("right-up", false)
			elif Input.is_action_pressed(get_player_event("right")) && Input.is_action_pressed(get_player_event("down")):
				control.shot("right-down", false)
			elif Input.is_action_pressed(get_player_event("up")):
				control.shot("up", false)
			elif Input.is_action_pressed(get_player_event("down")):
				control.shot("down", false)
			else:
				control.shot("right", false)

			activate = true

	if !activate:
		return

	var initialX = movement.x
	var initialY = movement.y
	var boost_speed = 0

	# move
	if Input.is_action_pressed(get_player_event("right")):
		movement.x = PLAYER_SPEED + boost_speed
	if Input.is_action_pressed(get_player_event("left")):
		movement.x = -(PLAYER_SPEED + boost_speed)
	if Input.is_action_pressed(get_player_event("up")):
		movement.y = -(PLAYER_SPEED + boost_speed)
	if Input.is_action_pressed(get_player_event("down")):
		movement.y = PLAYER_SPEED + boost_speed

	# the player doens't move
	if initialX == movement.x && initialY == movement.y:
		movement.x = 0
		movement.y = 0

	var motion = movement * delta
	move(motion)

