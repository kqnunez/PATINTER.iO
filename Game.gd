extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerNo := 0
var playAreaLayout := 3
var playerRole
var playerName

# Called when the node enters the scene tree for the first time.
func _ready():
	$DefenderBorder/CollisionShape2D/GameArea.set_texture(load("res://Assets/PlayArea%s.png" % (String(playAreaLayout)))) # Replace with function body.
	$TimeLeftLabel.connect("timeout", self, "_on_timeout")
	#Assign player role and name
	#Adjust this part to handle multiple players
	if playerRole == 0:
		$Player._set_layers(3)
		$Player.playerRole = "Runner"
		$Player.set_position(Vector2(510, 750))
	else:
		$Player._set_layers(5)
		#For ease of demo only. Would also need to assign horizontal defenders in layouts 2 and 3 in multiplayer
		if playAreaLayout == 2 or playAreaLayout == 3:
			$Player.playerRole = "Vertical Defender"
		else:
			$Player.playerRole = "Horizontal Defender"

	$Player.playerName = playerName
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	if playerRole == 0 and 0:
		pass

func _on_ExitButton_pressed():
	get_tree().quit()


func _on_Area2D_body_entered(body):
	#When ending line passed by Runner, shows GameOverRunner and disables player input.
	$GameOverScreen.show();
	$GameOverScreen/TimeoutScreen.hide();
	$Player.isGameOver = true

func _on_timeout():
	$GameOverScreen.show();
	$GameOverScreen/RunnerWinScreen.hide();
	$Player.isGameOver = true
