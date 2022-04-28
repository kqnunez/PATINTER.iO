class_name PlayerHistory extends Resource


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var name
var date # int array of [month, date, year]
var time # int array of [hour, minute]
var role
var runnerScore
var defenderScore

func _init(name:="", date:=[], time:=[], role:="", runnerScore:=0, defenderScore:=0):
	self.name = name
	self.date = date
	self.time = time
	self.role = role
	self.runnerScore = runnerScore
	self.defenderScore = defenderScore
	pass

func getData():
	return {
		"name": self.name,
		"date": self.date,
		"time": self.time,
		"role": self.role,
		"runnerScore": self.runnerScore,
		"defenderScore": self.defenderScore
		}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
