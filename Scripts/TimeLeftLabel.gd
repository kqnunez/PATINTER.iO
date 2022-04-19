extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal timeout

const interval = 1
var time = 1000 # this notes how much seconds we count down from.
var cur_time = time
var timerEnabled = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timerEnabled:
		cur_time = cur_time - delta
		if (cur_time <= time - interval and cur_time > 0):
			time = ceil(cur_time)
		if (cur_time <= 0):
			cur_time = 0
			time = 0
			emit_signal("timeout")
		$Timer.text = str(time)
