extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#const PlayerHistory = preload("res://PlayerHistory.gd")
#const GameHistory = preload("res://GameHistory.gd")
#const SaveLoadGame = preload("res://SaveLoadGame.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	var playerHistory = PlayerHistory.new()
	var gameHistory = GameHistory.new()
	var saveLoadGame = SaveLoadGame.new()
	
	print(gameHistory.getData())
	saveLoadGame.loadData(false)
	print(saveLoadGame.data)
	print("Data Loaded in Start_ExitGameUI")
	

# Testing the saving of game history and player history

# Testing the loading of game history and player history

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_startButton_pressed():
	get_tree().change_scene("res://InputNoOfPlayer_PlayAreaLayoutUI.tscn")

func _on_exitButton_pressed():
	var playerHistory = PlayerHistory.new()
	var gameHistory = GameHistory.new()
	var saveLoadGame = SaveLoadGame.new()
	gameHistory._init([3,16,2022], [23,30], "Runner", 1, 2)
	saveLoadGame.data = gameHistory.getData()
	saveLoadGame.saveData(false)
	get_tree().quit()
