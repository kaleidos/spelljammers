
extends RigidBody2D

var direction = Vector2(-1, 0)
var activate = true
var ball_speed = 150

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	print(get_colliding_bodies())
	var pos = get_pos()
	if activate:
		pos += direction * ball_speed * delta
		set_pos(pos)

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

func _on_ball_body_enter( body ):
	print(body)
	if body.get_name() == 'player':
		activate = false
		get_node("/root/control").catch(body.get_name())
	elif body.get_name() == "top_limit" || body.get_name() == "bottom_limit":
		var normal = Vector2(0, 1)

		direction = normal.reflect(direction)


func _on_ball_body_enter_shape( body_id, body, body_shape, local_shape ):
	print(body)
