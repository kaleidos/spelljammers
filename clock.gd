
extends Label
var start
var seconds
var limit = 60

func _ready():
	start = OS.get_ticks_msec()
	set_fixed_process(true)

func _fixed_process(delta):
	var time = OS.get_ticks_msec()

	var newseconds = (time - start) / 1000
	if newseconds >= limit:
		get_tree().get_root().get_node("/root/init")._setScene("res://end.tscn")
	elif seconds != newseconds:
		seconds = newseconds
		set_text(str(limit - seconds))



