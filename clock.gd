
extends Label
var start
var seconds
var limit = 60

func _ready():
	start = OS.get_ticks_msec()
	set_fixed_process(true)

func _fixed_process(delta):
	var control = get_node("/root/control")
	var player1_points = control.player1_points
	var player2_points = control.player2_points
	var limit_points = control.limit_points

	if player1_points >= limit_points:
		control.end()
	elif player2_points >= limit_points:
		control.end()
	else:
		var time = OS.get_ticks_msec()
		var newseconds = (time - start) / 1000

		if newseconds >= limit:
			control.end()
		elif seconds != newseconds:
			seconds = newseconds

			var time_remaing = limit - seconds

			if time_remaing == 10:
				set("custom_colors/font_color", "#d71b1b")

			set_text(str(time_remaing))

