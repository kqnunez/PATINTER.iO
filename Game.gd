extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerNo := 0
var playAreaLayout := 3
var playerRole
var playerName
var date
var time

var gameOverFlag = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	var dt = OS.get_datetime()
	self.date = [dt["month"], dt["day"], dt["year"]]
	self.time = [dt["hour"], dt["minute"]]
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

	if playerName:
		$Player.playerName = playerName
	
	#Additional dummy players to test collisions between players
	$Player2._set_layers(3)
	$Player2.playerRole = "Runner"
	$Player2.playerName = "Player2"
	
	$Player3._set_layers(5)
	$Player3.playerRole = "Horizontal Defender"
	$Player3.playerName = "Player3"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	if playerRole == 0 and 0:
		pass

func _on_ExitButton_pressed():
	var playerHistory = PlayerHistory.new()
	var gameHistory = GameHistory.new()
	var saveLoadGame = SaveLoadGame.new()
	var role
	if self.playerRole == 0:
		role = "Runner"
	else:
		role = "Defender"
	playerHistory._init(self.playerName, self.date, self.time, role, 0, 0)
	gameHistory._init(self.date, self.time, role, 0, 0)
	saveLoadGame.data = playerHistory.getData()
	saveLoadGame.saveData("player")
	saveLoadGame.data = gameHistory.getData()
	saveLoadGame.saveData("game")
	get_tree().quit()


func _on_Area2D_body_entered(body):
	showGameOverScreen(1)

func _on_timeout():
	showGameOverScreen(2)

func showGameOverScreen(screenType):
	if not gameOverFlag:
		$GameOverScreen.show();
		if screenType == 1:
			$GameOverScreen/TimeoutScreen.hide();
		elif screenType == 2:
			$GameOverScreen/RunnerWinScreen.hide();
		#Make sure to replace this with a for loop
		$Player.isGameOver = true
		$TimeLeftLabel.timerEnabled = false
	
