
extends Label
var start
var seconds
var limit = 60

func _ready():
	start = OS.get_ticks_msec()
	set_fixed_process(true)

func _fixed_process(delta):
	var player1_points = get_node("/root/control").player1_points
	var player2_points = get_node("/root/control").player2_points
	var limit_points = get_node("/root/control").limit_points
	
	if player1_points >= limit_points:
		print("limit player1")
		#get_node("/root/control").set_scene("res://end.tscn")
	elif player2_points >= limit_points:
		print("limit player2")
		#get_node("/root/control").set_scene("res://end.tscn")
		
	var time = OS.get_ticks_msec()
	var newseconds = (time - start) / 1000
	
	if newseconds >= limit:
		print("timer")
		get_node("/root/control").set_scene("res://end.tscn")
	elif seconds != newseconds:
		seconds = newseconds
		set_text(str(limit - seconds))



