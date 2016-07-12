
extends Label
var start
var seconds

func _ready():
	start = OS.get_ticks_msec()
	set_fixed_process(true)

func _fixed_process(delta):
	var time = OS.get_ticks_msec()

	var newseconds = (time - start) / 1000

	if seconds != newseconds:
		seconds = newseconds
		set_text(str(60 - seconds))



