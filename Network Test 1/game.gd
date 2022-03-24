extends Node

#Some code reused from Multiplayer Bomber Template, and WebSocket Multiplayer Demo, both licensed under the MIT License

const DEFAULT_PORT = 10567
var peer = null
var player_name =  "Computer 1"
var players = {}

signal refresh_player_list()
signal connection_failed()
signal connection_succeeded()

func _player_connected(id):
	rpc_id(id, "add_player", player_name)
	
func _connected_fail():
	get_tree().set_network_peer(null) # Remove peer
	emit_signal("connection_failed")
	
func _connected_ok():
	# We just connected to a server
	emit_signal("connection_succeeded")
	
remote func add_player(input_player_name):
	var player_id = get_tree().get_rpc_sender_id()
	players[player_id] = input_player_name
	emit_signal("refresh_player_list")
	
func host_game(input_player_name):
	player_name = input_player_name
#	peer = NetworkedMultiplayerENet.new()
#	peer.create_server(DEFAULT_PORT, 12)
#	get_tree().set_network_peer(peer)
	peer = WebSocketServer.new()
	peer.listen(DEFAULT_PORT, PoolStringArray(["test"]), true)
	get_tree().set_network_peer(peer)
	
func join_game(ip, input_player_name):
	player_name = input_player_name
#	peer = NetworkedMultiplayerENet.new()
#	peer.create_client(ip, DEFAULT_PORT)
#	get_tree().set_network_peer(peer)
	peer = WebSocketClient.new()
	peer.connect_to_url("ws://" + ip + ":" + str(DEFAULT_PORT), PoolStringArray(["test"]), true)
	get_tree().set_network_peer(peer)

func get_player_list():
	return players.values()

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
