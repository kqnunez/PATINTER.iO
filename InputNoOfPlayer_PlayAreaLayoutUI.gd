extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerNo := 0
var playAreaLayout := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_roleSelectButton_pressed():
	playerNo = int($gameSettingMenu/verticalCenter/sideMargins/menuButtons/noOfPlayers/noOfPlayersInput.get_text())
	get_tree().change_scene("res://InputPlayerRole_NameUI.tscn")
	SceneManager.passPlayerNoLayout("res://InputNoOfPlayer_PlayAreaLayoutUI.tscn", "res://InputPlayerRole_NameUI.tscn")
	
func _on_back_pressed():
	get_tree().change_scene("res://Start_ExitGameUI.tscn")
