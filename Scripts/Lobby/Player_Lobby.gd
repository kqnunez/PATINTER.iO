extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var playerNo := 0
var playAreaLayout := 0
var playerRole := 0	#This is the server's role
var playerName := "Pat Interio"
var lobbyName := "Pat's Lobby"

# Called when the node enters the scene tree for the first time.
func _ready():
	NetworkScript.connect("refresh_player_list", self, "refresh_list")
	
	$centerTitle/lobbyName.set_text(lobbyName)
	for i in range(1, 9):
		if i > playerNo:
			get_tree().get_root().find_node("playerLabel" + String(i), true, false).set_visible(false)
	refresh_list()
	
	
	#Hide extra labels
	if is_network_master():
		$centerMenu/menuButtons/roles/players1to4/playerLabel1.set_text(playerName+" RUNNER")
	#$centerMenu/menuButtons/roleSelect/inputControls/playerNameInput.set_text(playerName)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func refresh_list():
	print("Refreshing")
	var player_list = NetworkScript.get_player_list()
	playerName = $centerMenu/menuButtons/roleSelect/inputControls/playerNameInput.get_text()
	
	var role = " RUNNER"
	
	if playerRole == 0:
		$centerMenu/menuButtons/roleSelect/inputControls/roleSelectInput.set_text("RUNNER")
		$centerMenu/menuButtons/roles/players1to4/playerLabel1.set_text(playerName + " RUNNER")
	else:
		$centerMenu/menuButtons/roleSelect/inputControls/roleSelectInput.set_text("DEFENDER")
		$centerMenu/menuButtons/roles/players1to4/playerLabel1.set_text(playerName + " DEFENDER")
		
	for player_info in player_list:
		if player_info[2] == 1:
			role = " DEFENDER"
		get_tree().get_root().find_node("playerLabel" + String(player_info[1] +1), true, false).set_text(player_info[0] + role)

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
	print("Disabled For Debug")
	#Scene_Manager.passPlayerNoLayout(self, "res://PlayGameUI.tscn")
	
func _on_roleSelectInput_pressed():
	#playerName = $centerMenu/menuButtons/roleSelect/inputControls/playerNameInput.get_text()
	var newName = $centerMenu/menuButtons/roleSelect/inputControls/playerNameInput.get_text()
	if get_tree().is_network_server():
		if playerRole == 0:
			playerRole = 1
#			$centerMenu/menuButtons/roleSelect/inputControls/roleSelectInput.set_text("DEFENDER")
#			$centerMenu/menuButtons/roles/players1to4/playerLabel1.set_text(playerName + " DEFENDER")
		else:
			playerRole = 0
#			$centerMenu/menuButtons/roleSelect/inputControls/roleSelectInput.set_text("RUNNER")
#			$centerMenu/menuButtons/roles/players1to4/playerLabel1.set_text(playerName + " RUNNER")
	print("requesting change role and name")
	NetworkScript.request_change_role()
	NetworkScript.request_name_change(newName)
	refresh_list()

#remote func changePlayerRole():
#	var id = get_tree().get_rpc_sender_id()
#	print("Player Role changed for " + String(id))
#	var player_list = NetworkScript.get_player_list()
#	var player = player_list[id] #remember: player name, player number, player role.
#
#	if player[2] == 0:
#		player[2] = 1
##		get_tree().get_root().find_node("playerLabel" + String(player[1] +1), true, false).set_text(player[0] + " DEFENDER")
##		$centerMenu/menuButtons/roleSelect/inputControls/roleSelectInput.set_text("DEFENDER")
#		#$centerMenu/menuButtons/roles/players1to4/playerLabel1.set_text(playerName + " DEFENDER")
#	else:
#		player[2] = 0
##		get_tree().get_root().find_node("playerLabel" + String(player[1] +1), true, false).set_text(player[0] + "RUNNER")
##		$centerMenu/menuButtons/roleSelect/inputControls/roleSelectInput.set_text("RUNNER")
#		#$centerMenu/menuButtons/roles/players1to4/playerLabel1.set_text(playerName + " RUNNER")
