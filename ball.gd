
extends Area2D

var direction = Vector2(-2, 0)
var activate = true

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if activate:
		translate(direction)

func _on_ball_body_enter( body ):
	if body.get_name() == 'player':
		activate = false
		get_node("/root/control").catch(body.get_name())

		#var player_pos = player.get_pos()
		#set_global_pos(player_pos)

func shot(type):
	direction = Vector2(2, 0)
#	if type == "right-top-right":
#		direction = Vector2(2, -2)
#	elif type == 2:
#		direction = Vector2(2, 2)
#	elif type == 3:
#		direction = Vector2(2, -4)
#	elif type == 4:
#		direction = Vector2(2, 4)
#	elif type == "right":
#		direction = Vector2(2, 0)

	activate = true