
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
var player_area = "left"
var control
var anim
var player_orientation = "right"

const SHOT_DURATION = 500 #TODO: configuratble?
const AXIS_SENSITIVITY = 0.3

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

func stop():
	set_animation("standing")

func set_player_orientation(new_orientation):
	player_orientation = new_orientation
	if player_orientation == 'left':
		get_node("Sprite").set_scale(Vector2(-1, 1))
	elif player_orientation == "right":
		get_node("Sprite").set_scale(Vector2(1, 1))

func reset_player_orientation():
	var player_area = get_player_area()

	if player_area == "left":
		set_player_orientation("right")
	elif player_area == "right":
		set_player_orientation("left")

func has_the_ball():
	return state == "catch_ball"

func set_player_config(config):
	player_config = config

func get_last_catch_time():
	return last_catch_time

func set_action(action_name):
	if action_name == "dash":
		block_action_dash = true
	elif action_name == "catch_ball":
		last_catch_time = OS.get_ticks_msec()
		block_action_shot = true
		block_action_dash = true

	state = action_name

func search_speed_by_time(list_speeds, time):
	for shot_config in list_speeds:
		if "max" in shot_config && shot_config["min"] <= time && shot_config["max"] >= time:
			return shot_config.speed
		elif not "max" in shot_config && shot_config["min"] <= time:
			return shot_config.speed

func get_speed(player_axis, time,is_secondary):
	if player_axis.x < 0:
		player_axis.x = -player_axis.x

	if player_axis.x > 1:
		player_axis.x = 1

	if is_secondary:
		return search_speed_by_time(player_config.shots_strength.secondary, time)

	if !is_axis_pressed():
		return search_speed_by_time(player_config.shots_strength.straight, time)

	for shot_config in player_config.shots_strength.normal_shots:
		if player_axis.x >= shot_config.min_angle && shot_config.max_angle >= player_axis.x:
			return search_speed_by_time(shot_config.speeds, time)

	print(player_axis)
	print(time)
	print(is_secondary)

func shot(player_axis, is_secondary):
	last_shot_time = OS.get_ticks_msec()

	var player_area = get_player_area()
	var diff = last_shot_time - last_catch_time
	var ball = control.get_ball()

	#normalize shot angle
	if player_area  == "left":
		if player_axis.x < player_config.min_shot_angle:
			player_axis.x = player_config.min_shot_angle
	elif player_area  == "right":
		if player_axis.x > -player_config.min_shot_angle:
			player_axis.x = -player_config.min_shot_angle

	var speed = get_speed(player_axis, diff, is_secondary)

	# a/b = c/x  -> (b/a = c/x) // ((a*c)/b)
	if is_secondary:
		var player_area = get_player_area()
		var player_area_width = 328
		var player_area_height = 334
		var min_area2 = 340
		var max_area2 = 540
		var min_area1 = 70
		var max_area1 = 256
		var x
		var y

		if diff != 0:
			if player_area == "left":
				x = min_area2 + ((100 * player_area_width) / diff)
				if x > max_area2:
					x = max_area2

			else:
				x = diff * 100 / player_area_width
				if x < min_area1:
					x = min_area1
				elif x > max_area1:
					x = max_area1

		elif player_area == "right":
			x = min_area1
		else:
			x = min_area2

		if is_axis_pressed():
			var percent = ((player_area_height / 2) * (player_axis.y * 100)) / 100
			y =  get_pos().y + percent
		else:
			y = get_pos().y


		if y > player_area_height:
			y = 320
		elif y < 70:
			y = 90

		var destination = Vector2(x, y)

		set_action("idle")
		ball.shot2(destination, speed)
	else:
		set_action("idle")
		if !is_axis_pressed():
			if player_area == "left":
				ball.shot(Vector2(1, 0), speed)
			else:
				ball.shot(Vector2(-1, 0), speed)
		else:
			ball.shot(player_axis.normalized(), speed)


func catch():
	reset_player_orientation()
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
	return player_area

func set_player_area(area):
	player_area = area

	if area == "right":
		set_player_orientation("left")
	else:
		set_player_orientation("right")

func is_action_pressed(action):
	return Input.is_action_pressed(get_player_event(action))

func is_action_key_pressed():
	if is_action_pressed("main"):
		return true

	return false

func is_axis_pressed():
	var axis_pos = get_axis_pos()
	if axis_pos.x > AXIS_SENSITIVITY || axis_pos.x < -AXIS_SENSITIVITY:
		return true

	if axis_pos.y > AXIS_SENSITIVITY || axis_pos.y  < -AXIS_SENSITIVITY:
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
	if player_area == "right":
		return "player2_" + event
	else:
		return "player1_" + event

func get_player_ball_position():
	var pos = get_pos()

	if player_area == "right":
		pos.x -= 40
		return pos
	else:
		pos.x += 40
		return pos

func is_automatic_shot():
	var current_time = OS.get_ticks_msec()
	return (current_time - last_catch_time) >= player_config.time_automatic_shot

func get_axis_pos():
	var player_device = get_player_device()
	return  Vector2(Input.get_joy_axis(player_device, 0), Input.get_joy_axis(player_device, 1))

func shot_animation():
	pass

func set_animation(new_anim):
	if (new_anim != anim):
		if (new_anim == 'stop'):
			get_node("anim").stop()
		else:
			if new_anim == "walk-front":
				get_node("anim").play("start-front")
				get_node("anim").queue(new_anim)
			elif new_anim == "walk-lateral":
				get_node("anim").play("start-lateral")
				get_node("anim").queue(new_anim)
			else:
				get_node("anim").play(new_anim)

		anim = new_anim

func get_player_device():
	if get_player_area() == "left":
		return 0
	elif get_player_area() == "right":
		return 1

func _fixed_process(delta):
	var new_anim = "standing"
	var new_reverse_siding = true

	if !control.main_loop:
		return

	var current_time = OS.get_ticks_msec()

	if !is_action_key_pressed() && state == 'idle':
		block_action_dash = false

	if !is_action_key_pressed() && state == 'catch_ball':
		block_action_shot = false

	# shot
	if are_shot_available() && (is_action_pressed("main") || is_action_pressed("secondary") || is_automatic_shot()):
		var is_secondary = is_action_pressed("secondary")
		var player_axis = get_axis_pos()

		shot(player_axis, is_secondary)

	# movement
	movement.x = 0
	movement.y = 0

	var initialX = movement.x
	var initialY = movement.y

	# check dash duration
	if state == "dash" && (current_time - last_dash_init_time) >= player_config.dash_duration:
		set_action("idle")

	if are_move_actions_available():
		var player_area = get_player_area()

		if is_action_pressed("main") && is_axis_pressed() && !block_action_dash:
			last_dash_init_time = current_time
			#dash_orientation = get_player_orientation()
			dash_orientation = get_axis_pos()
			set_action("dash")
		# move
		else:
			var axis_pos = get_axis_pos()

			if axis_pos.x > AXIS_SENSITIVITY || axis_pos.x < -AXIS_SENSITIVITY:
				movement.x = axis_pos.x * player_config.player_speed

			if axis_pos.y > AXIS_SENSITIVITY || axis_pos.y  < -AXIS_SENSITIVITY:
				movement.y = axis_pos.y * player_config.player_speed

			if axis_pos.y > AXIS_SENSITIVITY:
				new_anim = "walk-front"
			elif axis_pos.y < -AXIS_SENSITIVITY:
				new_anim = "walk-back"

			if axis_pos.x > AXIS_SENSITIVITY:
				new_anim = "walk-lateral"
				set_player_orientation("right")
			elif axis_pos.x < -AXIS_SENSITIVITY:
				new_anim = "walk-lateral"
				set_player_orientation("left")

	#dash
	elif state == "dash":
		movement = dash_orientation * player_config.dash_speed

	if initialX != movement.x || initialY != movement.y:
		var motion = movement * delta

		if test_move(motion):
			new_anim = "standing"

		move(motion)

	set_animation(new_anim)
