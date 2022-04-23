extends Node

const DEFAULT_PORT = 10567
var peer = null
var player_name =  ""
var players = {}
var cur_player_no = 1;

signal refresh_player_list()
signal connection_failed()
signal connection_succeeded()

#Lobby Management Stuff
#As per docs, first five signals are called automatically on the server as player connect/disconnect happens.
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

#Signal events code modified from Godot docs.
func _player_connected(id):
	print("Player Connected!")
	rpc_id(id, "add_player", player_name)
	#emit_signal("refresh_player_list")

func _player_disconnected(id):
	players.erase(id)
	emit_signal("refresh_player_list")

func _connected_ok():
	print("Connected OK")
	emit_signal("connection_succeeded")

func _connected_fail():
	print("Connection Fail")
	get_tree().set_network_peer(null)
	emit_signal("connection_fail")
	
func _server_disconnected():
	print("Server Has Disconnected")

remote func add_player(player_name_input):
	print("add player")
	var player_id = get_tree().get_rpc_sender_id()
	
	#Always initialize a player to be a runner
	var player_role = 0
	var player_info = [player_name_input, cur_player_no, player_role]
	players[player_id] = player_info
	emit_signal("refresh_player_list")

func request_change_role():
	print("Requesting Role Change")
	emit_signal("refresh_player_list")
	rpc("change_player_role")
	
remote func change_player_role():
	var player_id = get_tree().get_rpc_sender_id()
	print("Role Change for " + String(player_id))
	if player_id != 0:
		var cur_player = players[player_id]
		if cur_player[2] == 0:
			cur_player[2] = 1
		else:
			cur_player[2] = 0
	emit_signal("refresh_player_list")
	
func request_name_change(name):
	print("Requesting Name Change")
	emit_signal("refresh_player_list")
	rpc("change_player_name", name)

remote func change_player_name(name):
	var player_id = get_tree().get_rpc_sender_id()
	print("Name Change for " + String(player_id))
	if player_id != 0:
		var cur_player = players[player_id]
		cur_player[0] = name
	emit_signal("refresh_player_list")
	
func host_game(player_name_input):
	print("Host Game")
	player_name = player_name_input
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, 8)
	get_tree().set_network_peer(peer)
#	peer = WebSocketServer.new()
#	peer.listen(DEFAULT_PORT, PoolStringArray(["test"]), true)
#	get_tree().set_network_peer(peer)
		
	
func join_game(ip, player_name_input):
	player_name = player_name_input
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(peer)
#	peer = WebSocketClient.new()
#	peer.connect_to_url("ws://" + ip + ":" + str(DEFAULT_PORT), PoolStringArray(["test"]), true)
#	get_tree().set_network_peer(peer)
	
func get_player_list():
	return players.values()

