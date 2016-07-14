extends KinematicBody2D

var movement = Vector2()
var direction = Vector2(-1, 0)
var activate = true
var ball_speed
var anim = ""
var shot2_active = false
var shot2_destination
var shot2_end

func collide(f1, f2):
	var width = 25
	var height = 25

	if (f1.x < f2.x + width &&
	   f1.x + width > f2.x &&
	   f1.y < f2.y + height &&
	   f1.height + f1.y > f2.y):
		return true
	return false

func _ready():
	set_fixed_process(true)

func is_ball():
	return true

func deactivate():
	activate = false

func hide():
	set_hidden(true)

func reset():
	activate = false
	show()
	get_node("sprite").set_scale(Vector2(1, 1))

func arrive_shot2_destination():
	var ball_pos = get_pos()

	if collide(ball_pos, shot2_destination):
		if OS.get_ticks_msec() >= shot2_end - 300:
			set_layer_mask_bit(1, true)
			set_collision_mask_bit(1, true)

		if get_node("sprite").get_scale().x == 0.8:
			deactivate()
			if get_pos().x > 330:
				get_node("/root/control").points(2, 0)
			else:
				get_node("/root/control").points(0, 2)

func _fixed_process(delta):
	var new_anim = "stop"

	if activate:
		new_anim = "spin"
		movement = direction * ball_speed * delta
		move(movement)

		if shot2_active:
			new_anim = "shot2"
			arrive_shot2_destination()

		if is_colliding() && get_collider().has_method("is_player"):
			activate = false

			var player = get_collider()

			player.catch()
			var position = player.get_player_ball_position()
			set_pos(position)
		elif is_colliding():
			var n = get_collision_normal()
			direction = n.reflect(direction)

	# Animation
	if (new_anim != anim):
		if (new_anim == 'stop'):
			get_node("anim").stop()
		else:
			get_node("anim").play(new_anim)

		anim = new_anim


func shot(shot_direction, speed):
	shot2_active = false
	ball_speed = speed
	direction = shot_direction
	activate = true

func shot2(destination, speed):
	ball_speed = speed
	shot2_destination = destination
	shot2_active = true

	direction = (shot2_destination - get_pos()).normalized()

	var distance = get_pos().distance_to(shot2_destination)
	var animation = get_node("anim")
	var animation_time = distance / speed
	var shot2Animation = Animation.new()

	shot2_end = OS.get_ticks_msec() + (animation_time * 1000)

	animation.add_animation("shot2", shot2Animation)
	animation.set_current_animation("shot2")
	animation.set_speed(1)
	shot2Animation.add_track(0)
	shot2Animation.set_length(animation_time)
	shot2Animation.set_step(0.1)
	shot2Animation.set_loop(false)
	shot2Animation.track_set_path(0, "/root/stadium/ball/sprite:transform/scale")
	shot2Animation.value_track_set_continuous(0, true)
	shot2Animation.track_insert_key(0, 0.0, Vector2(1, 1))
	shot2Animation.track_insert_key(0, animation_time / 2, Vector2(4, 4))
	shot2Animation.track_insert_key(0, animation_time, Vector2(0.8, 0.8))

	set_layer_mask_bit(1, false)
	set_collision_mask_bit(1, false)

	activate = true