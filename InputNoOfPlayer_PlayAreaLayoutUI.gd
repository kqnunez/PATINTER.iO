extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerNo := 0
var playAreaLayout := 0
var playAreaCurrent = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$menuCenter/menuButtons/playAre/setPlayArea/playAreaPreview.set_texture(load("res://Assets/playArea01.png"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_roleSelectButton_pressed():
	playerNo = int($menuCenter/menuButtons/noOfPlayers/noOfPlayersInput.get_text())
	if playerNo < 2 or playerNo > 8:
		$invalidPlayerNo.popup_centered()
		return
	playAreaLayout = playAreaCurrent
	SceneManager.passPlayerNoLayout(self, "res://InputPlayerRole_NameUI.tscn")
	
func _on_back_pressed():
	get_tree().change_scene("res://Start_ExitGameUI.tscn")


func _on_playAreaNext_pressed():
	if playAreaCurrent < 4:
		playAreaCurrent += 1
		$menuCenter/menuButtons/playAre/setPlayArea/playAreaPreview.set_texture(load("res://Assets/playArea0"+str(playAreaCurrent)+".png"))

func _on_playAreaPrev_pressed():
	if playAreaCurrent > 1:
		playAreaCurrent -= 1
		$menuCenter/menuButtons/playAre/setPlayArea/playAreaPreview.set_texture(load("res://Assets/playArea0"+str(playAreaCurrent)+".png"))
