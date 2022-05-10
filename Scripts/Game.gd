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
	
	NetworkScript.connect("show_game_over", self, "showGameOverScreen")
	
	var dt = OS.get_datetime()
	self.date = [dt["month"], dt["day"], dt["year"]]
	self.time = [dt["hour"], dt["minute"]]
	$Map.set_texture(load("res://Assets/playArea0%s.png" % (String(playAreaLayout)))) # Replace with function body.
	$GameDock/TimeExit/TimeLeftLabel.connect("timeout", self, "_on_timeout")
	#Assign player role and name
	#Adjust this part to handle multiple players
#	if playerRole == 0:
#		$Player._set_layers(3)
#		$Player.playerRole = "Runner"
#		$Player.set_position(Vector2(510, 750))
#	else:
#		$Player._set_layers(5)
#		#For ease of demo only. Would also need to assign horizontal defenders in layouts 2 and 3 in multiplayer
#		if playAreaLayout == 2 or playAreaLayout == 3:
#			$Player.playerRole = "Vertical Defender"
#		else:
#			$Player.playerRole = "Horizontal Defender"

#	$Player.playerName = playerName
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	pass

func _on_Area2D_body_entered(body):
	if body.playerRole == 4:
		showGameOverScreen(1)

func _on_timeout():
	showGameOverScreen(2)

func showGameOverScreen(screenType):
	$GameOverScreen.show();
	$GameOverScreen/GameOverText.show();
	if screenType == 1:
		$GameOverScreen/GameOverText/RunnerWinScreen.show();
	elif screenType == 2:
		$GameOverScreen/GameOverText/TimeoutScreen.show();
	elif screenType == 3:
		$GameOverScreen/GameOverText/DefenderWinScreen.show();
	#Make sure to replace this with a for loop
#		$Player.isGameOver = true
	#get_tree().set_pause(true)
	var player_entities = $Players.get_children()
	for entity in player_entities:
		entity.isGameOver = true
	$GameDock/TimeExit/TimeLeftLabel.timerEnabled = false
	


func _on_Exit_pressed():
	#get_tree().set_pause(false)
	var playerHistory = PlayerHistory.new()
	var gameHistory = GameHistory.new()
	var saveLoadGame = SaveLoadGame.new()
	var role
	
	#set up null values
	playerName = "Pat Interio"
	playerRole = 1
	date = [0,1]
	time = [1,2]
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
