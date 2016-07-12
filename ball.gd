extends KinematicBody2D

var movement = Vector2()
var direction = Vector2(-1, 0)
var activate = true
var ball_speed = 300
var anim = ""

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var new_anim = "stop"

	if activate:
		new_anim = "spin"
		movement = direction * ball_speed * delta
		move(movement)

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


func shot(type, player2):
	direction = Vector2(1, 0)
	if type == "left-up":
		direction = Vector2(-1, -2)
	elif type == "left-down":
		direction = Vector2(-1, 2)
	elif type == "right-up":
		direction = Vector2(1, -2)
	elif type == "right-down":
		direction = Vector2(1, 2)
	elif type == "down" && player2:
		direction = Vector2(-1, 4)
	elif type == "down" && !player2:
		direction = Vector2(1, 4)
	elif type == "up" && player2:
		direction = Vector2(-1, -4)
	elif type == "up" && !player2:
		direction = Vector2(1, -4)
	elif type == "right":
		direction = Vector2(1, 0)
	elif type == "left":
		direction = Vector2(-1, 0)

	activate = true

