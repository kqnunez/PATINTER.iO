extends Control


onready var game = get_node("Node")


func _ready():
	$Panel.show()
	game.connect("refresh_player_list", self, "refresh_list")
	game.connect("connection_failed", self, "_on_connection_failed")
	game.connect("connection_succeeded", self, "_on_connection_success")

func _on_Host_Button_pressed():
	$Panel.hide()
	$Panel2.show()
	
	var player_name = $"Panel/Name box".text
	game.host_game(player_name)
	refresh_list()


func _on_Join_Button_pressed():
	var player_name = $"Panel/Name box".text
	var ip = $Panel/"IP box".text
	if not ip.is_valid_ip_address():
		print("Invalid IP")
		return
	game.join_game(ip, player_name)
	
	$Panel/"Host Button".disabled = true
	$Panel/"Join Button".disabled = true

func _on_connection_success():
	$Panel.hide()
	$Panel2.show()
	
func refresh_list():
	var player_list = game.get_player_list()
	print(player_list)
	player_list.sort()
	$Panel2/ItemList.clear()
	$Panel2/ItemList.add_item(game.player_name)
	for player in player_list:
		$Panel2/ItemList.add_item(player)
	$Panel2/Button.disabled = not get_tree().is_network_server()
	print(player_list)

func _on_connection_failed():
	print("Connection Failed!")
	
	$Panel/"Host Button".disabled = false
	$Panel/"Join Button".disabled = false
	
