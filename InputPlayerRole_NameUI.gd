extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerNo := 0
var playAreaLayout := 0
var playerRole := 0
var playerName := "Merol Muspi"

# Called when the node enters the scene tree for the first time.
func _ready():
	#Hide extra labels
	for i in range(1, 9):
		if i > playerNo:
			get_tree().get_root().find_node("playerLabel" + String(i), true, false).set_visible(false)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_back_pressed():
	get_tree().change_scene("res://InputNoOfPlayer_PlayAreaLayoutUI.tscn")
	
func _on_startGameButton_pressed():
	playerName = $centermenu/menuButtons/nameRole/inputControls/playerNameInput.get_text()
	if playerName == "":
		$namePopups/noNameAlert.popup_centered()
		return
	for i in playerName:
		if not(ord(i) > 47 and ord(i) < 57):
			if not(ord(i) > 64 and ord(i) < 91):
				if not(ord(i) > 96 and ord(i) < 123):
					if ord(i) != 32:
						$namePopups/illegalCharacterAlert.popup_centered()
						return
	if playerName.length() > 15:
		$namePopups/longNameAlert.popup_centered()
		return
	SceneManager.passPlayerNoLayout(self, "res://move.tscn")

func _on_roleSelectInput_pressed():
	playerName = $centermenu/menuButtons/nameRole/inputControls/playerNameInput.get_text()
	
	if playerRole == 0:
		playerRole = 1
		$centermenu/menuButtons/nameRole/inputControls/roleSelectInput.set_text("DEFENDER")
		$centermenu/menuButtons/roles/players1to4/playerLabel1.set_text(playerName + " DEFENDER")
	else:
		playerRole = 0
		$centermenu/menuButtons/nameRole/inputControls/roleSelectInput.set_text("RUNNER")
		$centermenu/menuButtons/roles/players1to4/playerLabel1.set_text(playerName + " RUNNER")

