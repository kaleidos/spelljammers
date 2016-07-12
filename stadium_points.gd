
extends Sprite

func _ready():
	pass

func _on_3p1_body_enter( body ):
	if !body.has_method("is_ball"):
		return
	control = get_node("/root/control")

	if get_pos().x > 300:
		control.points(3, 0)
	else:
		control.points(0, 3)

func _on_5p_body_enter( body ):
	if !body.has_method("is_ball"):
		return

	control = get_node("/root/control")

	if get_pos().x > 300:
		control.points(5, 0)
	else:
		control.points(0, 5)


func _on_3p2_body_enter( body ):
	if !body.has_method("is_ball"):
		return

	control = get_node("/root/control")

	if get_pos().x > 300:
		control.points(3, 0)
	else:
		control.points(0, 3)
