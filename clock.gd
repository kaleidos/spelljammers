
extends Label
var start
var seconds
var limit = 5

func _ready():
	start = OS.get_ticks_msec()
	set_fixed_process(true)

func _fixed_process(delta):
	var time = OS.get_ticks_msec()

	var newseconds = (time - start) / 1000
	if newseconds >= limit:
		get_node("/root/stadium").setScene("res://end.tscn")
	elif seconds != newseconds:
		seconds = newseconds
		set_text(str(limit - seconds))



