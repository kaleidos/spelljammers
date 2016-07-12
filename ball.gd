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

		if is_colliding() && get_collider().get_name() == 'player':
			activate = false

			get_node("/root/control").catch(get_collider().get_name())

			var n = get_collision_normal()
			move(n)
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


func shot(type):
	direction = Vector2(1, 0)
	if type == "right-up":
		direction = Vector2(1, -2)
	elif type == "right-down":
		direction = Vector2(1, 2)
	elif type == "down":
		direction = Vector2(1, 4)
	elif type == "up":
		direction = Vector2(1, -4)
	elif type == "right":
		direction = Vector2(1, 0)

	activate = true

