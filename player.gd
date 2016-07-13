
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
# - shot strength depends in the time between the catch and the shot
# - automatic shot after x millisenconds

var movement = Vector2()
var state = "idle"
var player2 = false
var control

# shot
var block_action_shot = false
var last_shot_time = 0
var last_catch_time = 0

# dash
var block_action_dash = false
var last_dash_init_time
var dash_orientation

const PLAYER_SPEED = 220
const DASH_DURATION = 200
const DASH_SPEED = PLAYER_SPEED + 300
const SHOT_BLOCK_MOVEMENT = 300
const AUTOMATIC_SHOT = 2000

func _ready():
	control = get_node("/root/control")
	set_fixed_process(true)

func set_action(action_name):
	if action_name == "dash":
		block_action_dash = true
	elif action_name == "catch_ball":
		last_catch_time = OS.get_ticks_msec()
		block_action_shot = true
		block_action_dash = true

	state = action_name

func shot(type, is_player2, is_secondary):
	last_shot_time = OS.get_ticks_msec()
	var diff = last_shot_time - last_catch_time

	var ball = control.get_ball()

	var speed = 250
	if diff <= 100:
		speed = 800
	elif diff > 100 && diff <= 600:
		speed = 400

	# a/b = c/x  -> (b/a = c/x) // ((a*c)/b)
	if is_secondary:
		var player_area_width = 282
		var x
		var y

		if diff != 0:
			if !is_player2:
				x = 340 + ((100 * player_area_width) / diff)
				if x > 540:
					x = 540

			else:
				x = diff * 100 / player_area_width
				if x < 70:
					x = 70
				elif x > 256:
					x = 265
		elif player2:
			x = 70
		else:
			x = 340

		if type == "left-up" || type == "right-up":
			y = 130
		elif type == "left-down" || type == "right-down":
			y = 290
		elif type == "up":
			y = 100
		elif type == "down":
			y = 330
		else:
			y = 210

		#x = 540
		#y = 210

		var destination = Vector2(x, y)

		set_action("idle")
		ball.shot2(destination, 300)
	else:
		var direction = Vector2(1, 0)

		if type == "left-up":
			direction = Vector2(-1.5, -1)
		elif type == "left-down":
			direction = Vector2(-1.5, 1)
		elif type == "right-up":
			direction = Vector2(1.5, -1)
		elif type == "right-down":
			direction = Vector2(1.5, 1)
		elif type == "down" && is_player2:
			direction = Vector2(-1.5, 2)
		elif type == "down" && !is_player2:
			direction = Vector2(1.5, 2)
		elif type == "up" && is_player2:
			direction = Vector2(-1.5, -2)
		elif type == "up" && !is_player2:
			direction = Vector2(1.5, -2)
		elif type == "right":
			direction = Vector2(1, 0)
		elif type == "left":
			direction = Vector2(-1, 0)

		set_action("idle")

		ball.shot(direction.normalized(), speed)

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
		pos.x -= 40
		return pos
	else:
		pos.x += 40
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
	last_catch_time

	if are_shot_available() && (is_action_pressed("main") || is_action_pressed("secondary") || (current_time - last_catch_time) >= AUTOMATIC_SHOT):
		var is_secondary = is_action_pressed("secondary")

		if player2:
			if is_action_pressed("left") && is_action_pressed("up"):
				shot("left-up", true, is_secondary)
			elif is_action_pressed("left") && is_action_pressed("down"):
				shot("left-down", true, is_secondary)
			elif is_action_pressed("up"):
				shot("up", true, is_secondary)
			elif is_action_pressed("down"):
				shot("down", true, is_secondary)
			else:
				shot("left", true, is_secondary)
		else:
			if is_action_pressed("right") && is_action_pressed("up"):
				shot("right-up", false, is_secondary)
			elif is_action_pressed("right") && is_action_pressed("down"):
				shot("right-down", false, is_secondary)
			elif is_action_pressed("up"):
				shot("up", false, is_secondary)
			elif is_action_pressed("down"):
				shot("down", false, is_secondary)
			else:
				shot("right", false, is_secondary)

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