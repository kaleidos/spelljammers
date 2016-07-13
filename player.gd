
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
# - shot strength depends in the time between the catch and the shot
# - automatic shot after x millisenconds
# - TODO: the player is looking to the las place wher he was looking (left-right)

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

var player_config

func _ready():
	control = get_node("/root/control")
	set_fixed_process(true)
	
	
func set_player_config(config):
	player_config = config

func set_action(action_name):
	if action_name == "dash":
		block_action_dash = true
	elif action_name == "catch_ball":
		last_catch_time = OS.get_ticks_msec()
		block_action_shot = true
		block_action_dash = true

	state = action_name

func shot(type, is_secondary):
	last_shot_time = OS.get_ticks_msec()
	var diff = last_shot_time - last_catch_time

	var ball = control.get_ball()

	# max_speed = 1000 - 100ms
	# lower_speed = 100 - 500ms
	# 100 -> 1000 = 
	# 250ms??

	print(speed)

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
		
		if type != "straight":
			direction = player_config.shot_angles[type]
			
		var player_area = get_player_area()
		
		if player_area == "right":
			direction.x = -direction.x

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

	if (time - last_shot_time) < player_config.time_movement_block_after_shot:
		return false

	if state == "idle":
		return true

	return false

func is_player():
	return true
	
func get_player_area():
	if player2:
		return "right"
	else:
		return "left"

#TODO
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
		
func is_automatic_shot():
	var current_time = OS.get_ticks_msec()
	return (current_time - last_catch_time) >= player_config.time_automatic_shot

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

	if are_shot_available() && (is_action_pressed("main") || is_action_pressed("secondary") || is_automatic_shot()):
		var is_secondary = is_action_pressed("secondary")

		if is_action_pressed("left") && is_action_pressed("up"):
			shot("up-middle", is_secondary)
		elif is_action_pressed("left") && is_action_pressed("down"):
			shot("down-middle", is_secondary)
		elif is_action_pressed("up"):
			shot("up", is_secondary)
		elif is_action_pressed("down"):
			shot("down", is_secondary)
		else:
			shot("straight", is_secondary)

	# movement
	movement.x = 0
	movement.y = 0

	var initialX = movement.x
	var initialY = movement.y

	# check dash duration
	if state == "dash" && (current_time - last_dash_init_time) >= player_config.dash_duration:
		set_action("idle")

	if are_move_actions_available():
		if is_action_pressed("main") && is_axis_pressed() && !block_action_dash:
			last_dash_init_time = current_time
			dash_orientation = get_player_orientation()
			set_action("dash")
		# move
		else:
			if is_action_pressed("right"):
				movement.x = player_config.player_speed
			if is_action_pressed("left"):
				movement.x = -player_config.player_speed
			if is_action_pressed("up"):
				movement.y = -player_config.player_speed
			if is_action_pressed("down"):
				movement.y = player_config.player_speed
	#dash
	elif state == "dash":
			if dash_orientation == "up-left":
				movement.y = -player_config.dash_speed
				movement.x = -player_config.dash_speed
			elif dash_orientation == "up-right":
				movement.y = -player_config.dash_speed
				movement.x = player_config.dash_speed
			elif dash_orientation == "up":
				movement.y = -player_config.dash_speed
			if dash_orientation == "down-left":
				movement.y = player_config.dash_speed
				movement.x = -player_config.dash_speed
			elif dash_orientation == "down-right":
				movement.y = player_config.dash_speed
				movement.x = player_config.dash_speed
			elif dash_orientation == "down":
				movement.y = player_config.dash_speed
			elif dash_orientation == "left":
				movement.x = -player_config.dash_speed
			elif dash_orientation == "right":
				movement.x = player_config.dash_speed

	if initialX != movement.x || initialY != movement.y:
		var motion = movement * delta
		move(motion)