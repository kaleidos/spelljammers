
extends KinematicBody2D

# state
# - 'idle' without the ball
# - 'catch_ball' with the ball
# - 'dash' dash

# - when the player catch the ball `block_action_shot` is set to `true`, the shot is enable again when the player
#   is has the ball and doens't have any action button pressed
# - when the player dash `block_action_dash` is set to `true`, the dash is enable again when the player
#   is idle and doens't have any action button pressed
# - the movement is blocked after shot during x milliseconds, when the movevement is avalible again ignore the main action button util release
# - TODO: the player is looking to the las place wher he was looking (left-right)
# - TODO: shot strength depends in the time between the catch and the shot
# - TODO: automatic shot after x millisenconds

var movement = Vector2()
var state = "idle"
var player2 = false
var control

# shot
var block_action_shot = false
var last_shot_time = 0

# dash
var block_action_dash = false
var last_dash_init_time
var dash_orientation

const PLAYER_SPEED = 220
const DASH_DURATION = 200
const DASH_SPEED = PLAYER_SPEED + 300
const SHOT_BLOCK_MOVEMENT = 300

func _ready():
	control = get_node("/root/control")
	set_fixed_process(true)

func set_action(action_name):
	if action_name == "dash":
		block_action_dash = true
	elif action_name == "catch_ball":
		block_action_shot = true
		block_action_dash = true

	state = action_name

func catch():
	set_action("catch_ball")

func are_shot_available():
	if block_action_shot:
		return false

	if state == "catch_ball":
		return true

	return false

func are_move_actions_available():
	var time = OS.get_ticks_msec()

	if (time - last_shot_time) < SHOT_BLOCK_MOVEMENT:
		return false

	if state == "idle":
		return true

	return false

func is_player():
	return true

func setPlayer2():
	player2 = true
	get_node("Sprite").set_scale(Vector2(-1, 1))

func is_action_pressed(action):
	return Input.is_action_pressed(get_player_event(action))

func is_action_key_pressed():
	if is_action_pressed("main"):
		return true

	return false

func is_axis_pressed():
	if is_action_pressed("right"):
		return true
	elif is_action_pressed("left"):
		return true
	elif is_action_pressed("up"):
		return true
	elif is_action_pressed("down"):
		return true

	return false

func get_player_orientation():
	if is_action_pressed("up"):
		if is_action_pressed("right"):
			return "up-right"
		elif is_action_pressed("left"):
			return "up-left"
		else:
			return "up"
	elif is_action_pressed("down"):
		if is_action_pressed("right"):
			return "down-right"
		elif is_action_pressed("left"):
			return "down-left"
		else:
			return "down"
	elif is_action_pressed("left"):
		return "left"
	elif is_action_pressed("right"):
		return "right"

func get_player_event(event):
	if player2:
		return "player2_" + event
	else:
		return "player1_" + event

func get_player_ball_position():
	var pos = get_pos()

	if player2:
		pos.x -= 50
		return pos
	else:
		pos.x += 50
		return pos

func _fixed_process(delta):
	if !control.main_loop:
		return

	var current_time = OS.get_ticks_msec()

	if !is_action_key_pressed() && state == 'idle':
		block_action_dash = false

	if !is_action_key_pressed() && state == 'catch_ball':
		block_action_shot = false

	# shot
	if are_shot_available() && is_action_pressed("main"):
		if player2:
			if is_action_pressed("left") && is_action_pressed("up"):
				control.shot("left-up", true)
			elif is_action_pressed("left") && is_action_pressed("down"):
				control.shot("left-down", true)
			elif is_action_pressed("up"):
				control.shot("up", true)
			elif is_action_pressed("down"):
				control.shot("down", true)
			else:
				control.shot("left", true)

			set_action("idle")
		else:
			if is_action_pressed("right") && is_action_pressed("up"):
				control.shot("right-up", false)
			elif is_action_pressed("right") && is_action_pressed("down"):
				control.shot("right-down", false)
			elif is_action_pressed("up"):
				control.shot("up", false)
			elif is_action_pressed("down"):
				control.shot("down", false)
			else:
				control.shot("right", false)

			last_shot_time = current_time
			set_action("idle")

	# movement
	movement.x = 0
	movement.y = 0

	var initialX = movement.x
	var initialY = movement.y

	# check dash duration
	if state == "dash" && (current_time - last_dash_init_time) >= DASH_DURATION:
		set_action("idle")

	if are_move_actions_available():
		if is_action_pressed("main") && is_axis_pressed() && !block_action_dash:
			last_dash_init_time = current_time
			dash_orientation = get_player_orientation()
			set_action("dash")
		# move
		else:
			if is_action_pressed("right"):
				movement.x = PLAYER_SPEED
			if is_action_pressed("left"):
				movement.x = -PLAYER_SPEED
			if is_action_pressed("up"):
				movement.y = -PLAYER_SPEED
			if is_action_pressed("down"):
				movement.y = PLAYER_SPEED
	#dash
	elif state == "dash":
			if dash_orientation == "up-left":
				movement.y = -DASH_SPEED
				movement.x = -DASH_SPEED
			elif dash_orientation == "up-right":
				movement.y = -DASH_SPEED
				movement.x = DASH_SPEED
			elif dash_orientation == "up":
				movement.y = -DASH_SPEED
			if dash_orientation == "down-left":
				movement.y = DASH_SPEED
				movement.x = -DASH_SPEED
			elif dash_orientation == "down-right":
				movement.y = DASH_SPEED
				movement.x = DASH_SPEED
			elif dash_orientation == "down":
				movement.y = DASH_SPEED
			elif dash_orientation == "left":
				movement.x = -DASH_SPEED
			elif dash_orientation == "right":
				movement.x = DASH_SPEED

	if initialX != movement.x || initialY != movement.y:
		var motion = movement * delta
		move(motion)