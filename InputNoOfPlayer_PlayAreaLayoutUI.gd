extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerNo := 0
var playAreaLayout := 0
var playAreaCurrent = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$gameSettingMenu/verticalCenter/sideMargins/menuButtons/playAre/setPlayArea/playAreaPreview.set_texture(load("res://Assets/playArea1.png"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_roleSelectButton_pressed():
	playerNo = int($gameSettingMenu/verticalCenter/sideMargins/menuButtons/noOfPlayers/noOfPlayersInput.get_text())
	SceneManager.passPlayerNoLayout(self, "res://InputPlayerRole_NameUI.tscn")
	
func _on_back_pressed():
	get_tree().change_scene("res://Start_ExitGameUI.tscn")


func _on_playAreaNext_pressed():
	if playAreaCurrent < 4:
		playAreaCurrent += 1
		$gameSettingMenu/verticalCenter/sideMargins/menuButtons/playAre/setPlayArea/playAreaPreview.set_texture(load("res://Assets/playArea"+str(playAreaCurrent)+".png"))

func _on_playAreaPrev_pressed():
	if playAreaCurrent > 1:
		playAreaCurrent -= 1
		$gameSettingMenu/verticalCenter/sideMargins/menuButtons/playAre/setPlayArea/playAreaPreview.set_texture(load("res://Assets/playArea"+str(playAreaCurrent)+".png"))
