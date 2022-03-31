extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerNo := 0
var playAreaLayout := 0
var playerRole := 0
var playerName := "Pat Interio"
var lobbyName := "Pat's Lobby"

# Called when the node enters the scene tree for the first time.
func _ready():
	$centerTitle/lobbyName.set_text(lobbyName)
	#Hide extra labels
	for i in range(1, 9):
		if i > playerNo:
			get_tree().get_root().find_node("playerLabel" + String(i), true, false).set_visible(false)
	$centerMenu/menuButtons/roles/players1to4/playerLabel1.set_text(playerName+" RUNNER")
	$centerMenu/menuButtons/roleSelect/inputControls/playerNameInput.set_text(playerName)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_back_pressed():
	get_tree().change_scene("res://Create_Join_Game.tscn")
	
func _on_startGameButton_pressed():
	playerName = $centerMenu/menuButtons/roleSelect/inputControls/playerNameInput.get_text()
	if playerName == "":
		$namePopups/noNameAlert.popup_centered()
		return
	for i in playerName:
		if not(ord(i) > 47 and ord(i) < 58):
			if not(ord(i) > 64 and ord(i) < 91):
				if not(ord(i) > 96 and ord(i) < 123):
					if ord(i) != 32:
						$namePopups/illegalCharacterAlert.popup_centered()
						return
	Scene_Manager.passPlayerNoLayout(self, "res://PlayGameUI.tscn")

func _on_roleSelectInput_pressed():
	playerName = $centerMenu/menuButtons/roleSelect/inputControls/playerNameInput.get_text()
	
	if playerRole == 0:
		playerRole = 1
		$centerMenu/menuButtons/roleSelect/inputControls/roleSelectInput.set_text("DEFENDER")
		$centerMenu/menuButtons/roles/players1to4/playerLabel1.set_text(playerName + " DEFENDER")
	else:
		playerRole = 0
		$centerMenu/menuButtons/roleSelect/inputControls/roleSelectInput.set_text("RUNNER")
		$centerMenu/menuButtons/roles/players1to4/playerLabel1.set_text(playerName + " RUNNER")

