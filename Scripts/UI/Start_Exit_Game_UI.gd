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
	
	saveLoadGame.loadData("player")
	print("Player History data upon start:")
	print(saveLoadGame.data)
	saveLoadGame.loadData("game")
	print("Game History data upon start:")
	print(saveLoadGame.data)
	

# Testing the saving of game history and player history

# Testing the loading of game history and player history

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_start_button_pressed():
	get_tree().change_scene("res://Create_Join_Game.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
