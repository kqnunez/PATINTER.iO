extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerNo := 0
var playAreaLayout := 0
var playerRole := 0
var playerName := "Pat Interio"
var lobbyName := "Pat's Lobby"

var playerListNode 
# Called when the node enters the scene tree for the first time.
func _ready():
	NetworkScript.connect("refresh_player_list", self, "refresh_list")
	
	$centerTitle/lobbyName.set_text(lobbyName)
	$centerMenu/menuButtons/roleSelect/inputControls/playerNameInput.set_text(playerName)
	

	
	#Hide extra labels
	if get_tree().is_network_server():
		$playerListLeft.add_item(playerName+" RUNNER(You)")

func refresh_list():
	#print("Refreshing")
	var player_list = NetworkScript.get_player_list()
	print(player_list)
	var role = " RUNNER"
	playerName = $centerMenu/menuButtons/roleSelect/inputControls/playerNameInput.get_text()
	
	#var label = $playerLabel
	
	#clear list of players.
	$playerListLeft.clear()
	$playerListRight.clear()
	
	
	#Make sure current player is always at top of list.
	if playerRole == 0:
		$centerMenu/menuButtons/roleSelect/inputControls/roleSelectInput.set_text("RUNNER")
		$playerListLeft.add_item(playerName + " RUNNER(You)")
	else:
		$centerMenu/menuButtons/roleSelect/inputControls/roleSelectInput.set_text("DEFENDER")
		$playerListLeft.add_item(playerName + " DEFENDER(You)")
	
	#update other players in list.
	for player_info in player_list:
		if player_info[2] == 1:
			#print("ROLE WORD HAS CHANGED")
			role = " DEFENDER"
		else:
			role = " RUNNER"
		if player_info[1] > 4:
			$playerListRIght.visible = true
			$playerListRight.add_item(player_info[0] + String(role))
		else:
			$playerListLeft.add_item(player_info[0] + String(role))
		#$centerMenu/menuButtons/roleSelect/inputControls/roleSelectInput.set_text(role)
	
	$centerMenu/menuButtons/startGameButton.disabled = not get_tree().is_network_server()

func _on_back_pressed():
	get_tree().change_scene("res://Create_Join_Game.tscn")
	
func _on_startGameButton_pressed():
	if get_tree().is_network_server():
		NetworkScript.host_player_name = playerName
		NetworkScript.host_role = playerRole
		NetworkScript.begin_game()
		#print("Disabled For Debug")
		#Scene_Manager.passPlayerNoLayout(self, "res://PlayGameUI.tscn")
	
func _on_roleSelectInput_pressed():
	#playerName = $centerMenu/menuButtons/rolesSelect/inputControls/playerNameInput.get_text()
	var newName = $centerMenu/menuButtons/roleSelect/inputControls/playerNameInput.get_text()
	playerName = newName
	
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
	#change role and name locally, then pass it to the host.
	
#	if get_tree().is_network_server():
	if playerRole == 0:
		playerRole = 1
#			$centerMenu/menuButtons/roleSelect/inputControls/roleSelectInput.set_text("DEFENDER")
#			$centerMenu/menuButtons/roles/players1to4/playerLabel1.set_text(playerName + " DEFENDER")
	else:
		playerRole = 0
#			$centerMenu/menuButtons/roleSelect/inputControls/roleSelectInput.set_text("RUNNER")
#			$centerMenu/menuButtons/roles/players1to4/playerLabel1.set_text(playerName + " RUNNER")
	print(playerRole)
#	else:
	NetworkScript.request_change_role()
	NetworkScript.request_name_change(newName)
	refresh_list()
