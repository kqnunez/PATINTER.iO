extends Control


var playerNo := 2
var playAreaLayout := 0
var playAreaCurrent := 1
var playerName := "Pat Interio"
var lobbyName := "Room Interio"

#Network Stuff

# Called when the node enters the scene tree for the first time.
func _ready():
	$lobby_details_popup/lobby_popup_center/lobby_size_input/set_play_area/play_area_preview.set_texture(load("res://Assets/playArea01.png"))
	#$lobby_details_popup/lobby_popup_center/lobby_size_input/set_play_area/left_space/play_area_prev.hide()
	#$lobby_details_popup/lobby_popup_center/lobby_size_input/player_no_input/less_occupy/less.hide()
	
	NetworkScript.connect("connection_failed", self, "_on_connection_failed")
	NetworkScript.connect("connection_succeeded", self, "_on_connection_success")
	pass 

###
###	NETWORKING CODE
###
	
func _on_connection_failed():
	print("Connection Failed!")
	
func _on_connection_success():
	print("Connection Success!")
	

###
###	LOBBY CODE
###

func _on_back_pressed():
	get_tree().change_scene("res://Start_Exit_Game_UI.tscn")
	
func _on_join_lobby_pressed():
	#$bad_lobby.popup_centered()
	var ip = $"center_menu/menu_buttons/lobby_addr_input".text
	if not ip.is_valid_ip_address():
		print("Invalid IP")
		return
	if save_player_name():
		NetworkScript.join_game(ip, playerName)
		#$lobby_details_popup.popup()
		Scene_Manager.passPlayerNoLayout(self, "res://Player_Lobby.tscn")
		
func _on_create_lobby_pressed():
	if save_player_name() and save_lobby_addr():
		$lobby_details_popup.popup()
	NetworkScript.host_game(playerName)
		
	
func _on_create_game_pressed():
	playAreaLayout = playAreaCurrent
	
	Scene_Manager.passPlayerNoLayout(self, "res://Player_Lobby.tscn")
	
func _on_play_area_next_pressed():
	if playAreaCurrent == 3:
		$lobby_details_popup/lobby_popup_center/lobby_size_input/set_play_area/right_space/play_area_next.hide()
	playAreaCurrent += 1
	$lobby_details_popup/lobby_popup_center/lobby_size_input/set_play_area/play_area_preview.set_texture(load("res://Assets/playArea0"+str(playAreaCurrent)+".png"))
	if playAreaCurrent == 2:
		$lobby_details_popup/lobby_popup_center/lobby_size_input/set_play_area/left_space/play_area_prev.show()

func _on_play_area_prev_pressed():
	if playAreaCurrent == 2:
		$lobby_details_popup/lobby_popup_center/lobby_size_input/set_play_area/left_space/play_area_prev.hide()
	playAreaCurrent -= 1
	$lobby_details_popup/lobby_popup_center/lobby_size_input/set_play_area/play_area_preview.set_texture(load("res://Assets/playArea0"+str(playAreaCurrent)+".png"))
	if playAreaCurrent == 3:
		$lobby_details_popup/lobby_popup_center/lobby_size_input/set_play_area/right_space/play_area_next.show()

func _on_less_pressed():
	if playerNo == 3:
		$lobby_details_popup/lobby_popup_center/lobby_size_input/player_no_input/less_occupy/less.hide()
	playerNo -= 1
	$lobby_details_popup/lobby_popup_center/lobby_size_input/player_no_input/player_no.set_text(str(playerNo))
	if playerNo == 7:
		$lobby_details_popup/lobby_popup_center/lobby_size_input/player_no_input/more_occupy/more.show()
	
func _on_more_pressed():
	if playerNo == 7:
		$lobby_details_popup/lobby_popup_center/lobby_size_input/player_no_input/more_occupy/more.hide()
	playerNo += 1
	$lobby_details_popup/lobby_popup_center/lobby_size_input/player_no_input/player_no.set_text(str(playerNo))
	if playerNo == 3:
		$lobby_details_popup/lobby_popup_center/lobby_size_input/player_no_input/less_occupy/less.show()

func save_player_name():
	playerName = $center_menu/menu_buttons/player_name_input.get_text()
	if playerName == "":
		$name_popups/no_name_alert.popup_centered()
		return 0
	for i in playerName:
		if not(ord(i) > 47 and ord(i) < 58):
			if not(ord(i) > 64 and ord(i) < 91):
				if not(ord(i) > 96 and ord(i) < 123):
					if ord(i) != 32:
						$name_popups/illegal_character_alert.popup_centered()
						return 0
	return 1
	
func save_lobby_addr():
	lobbyName = $center_menu/menu_buttons/lobby_name_input.get_text()
	if lobbyName == "":
		$name_popups/no_name_alert.popup_centered()
		return 0
	for i in lobbyName:
		if not(ord(i) > 47 and ord(i) < 58):
			if not(ord(i) > 64 and ord(i) < 91):
				if not(ord(i) > 96 and ord(i) < 123):
					if ord(i) != 32:
						$name_popups/illegal_character_alert.popup_centered()
						return 0
	return 1
