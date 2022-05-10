extends Node

const DEFAULT_PORT = 10567
var peer = null
var player_name=  ""

var host_player_name = ""
var host_role = 0

var players = {}
var cur_player_no = 2

var layout = 0  #Determines the layout. 0 means only 2 defenders or layout A, 1 means 3 defenders or layouts B-D

var players_ready = []
var num_players = 2
signal refresh_player_list(player_list)
signal connection_failed()
signal connection_succeeded()

signal show_game_over(type)
#Lobby Management Stuff
#As per docs, first five signals are called automatically on the server as player connect/disconnect happens.
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	rpc_config("change_player_name",1) #allow players variable to be modified via rset.

#Signal events code modified from Godot docs.
func _player_connected(id):
	print("Player Connected!" + String(id))
	rpc_id(id, "add_player", player_name)
	#emit_signal("refresh_player_list")

func _player_disconnected(id):
	players.erase(id)
	print("PLAYER DISCONNECTED")
	print("NEW:", players)
	emit_signal("refresh_player_list", players)

func _connected_ok():
	print("Connected OK")
	emit_signal("connection_succeeded")

func _connected_fail():
	print("Connection Fail")
	get_tree().set_network_peer(null)
	emit_signal("connection_fail")
	
func _server_disconnected():
	print("Server Has Disconnected")

func request_disconnect():
	if not get_tree().is_network_server():
		var id = get_tree().get_network_unique_id()
		rpc_id(1, "player_disconnect", id)
	

remote func player_disconnect(id):
	peer.disconnect_peer(id)

remote func add_player(player_name_input):
	var player_id = get_tree().get_rpc_sender_id()
	
	#Always initialize a player to be a runner
	var player_role = 0
	var player_info = [player_name_input, cur_player_no, player_role]
	players[player_id] = player_info
	emit_signal("refresh_player_list", players)

func request_change_role(player_ID):
	print("Requesting Role Change")
	#emit_signal("refresh_player_list")
	if not get_tree().is_network_server():
		rpc_id(1,"change_player_role", player_ID)
	emit_signal("refresh_player_list", players)
	
remote func change_player_role(player_ID):
	#var player_id = get_tree().get_rpc_sender_id()
	print("Role Change for " + String(player_ID))
	print("Players before role change:")
	print(players)
	var cur_player = players[player_ID]
	if cur_player[2] == 0:
		cur_player[2] = 1
	else:
		cur_player[2] = 0
	print("Players after role change:")
	print(players)
	begin_peer_player_update(players)
	#emit_signal("refresh_player_list", players)
	
func request_name_change(name, player_ID):
	print("Requesting Name Change")
	#emit_signal("refresh_player_list")
	
	if not get_tree().is_network_server():
		#updates Host's players info
		rpc_id(1,"change_player_name", name, player_ID)
	#asks host to make peers update their player values.
	emit_signal("refresh_player_list", players)

remote func change_player_name(name, player_ID):
	#var player_id = get_tree().get_rpc_sender_id()
	print("Name Change for " + String(player_ID))
#	if player_ID != 1:
		#rset("players[" + String(player_id) + "][0]", name)
	var cur_player = players[player_ID]
	cur_player[0] = name
	
	begin_peer_player_update(players)
	emit_signal("refresh_player_list", players)
	
func begin_peer_player_update(new_player_list):
	#Only runs on Host. Goes to all peers and makes them change their player list
	for player_ID in players:
		if player_ID != 1:
			rpc_id(player_ID, "peer_player_update", new_player_list)
	
remote func peer_player_update(new_player_list):
	players = new_player_list
	emit_signal("refresh_player_list", players)
	
	
func host_game(player_name_input):
	print("Host Game")
	player_name = player_name_input
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, num_players)
	get_tree().set_network_peer(peer)
	
	players[1] = ["Pat Interio", 1, 0]
	# on host, populate players with default values for host.
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

func begin_game(gameLayout):
	if get_tree().is_network_server():
		var spawns = {}
		spawns[1] = 1 #host always player 1
		var index = 2
		for player in players:
			spawns[player] = index
			index += 1
		
		#We have to make sure that the spawn points are filled for all players before we go rpc.
		#We also make it so that each peer gets a copy of the latest players dict from the host.
		for player in players:
			if player != 1:
				rpc_id(player, "prep_game", spawns, players, gameLayout)
		
		prep_game(spawns, players, gameLayout)
	else:
		print("ERROR in begin_game")

remote func prep_game(spawns, host_players, layout):
	get_tree().set_pause(true)
	var game = load("res://PlayGameUI.tscn").instance()
	game.playAreaLayout = layout
	
	get_tree().get_root().add_child(game)
	#get_tree().get_root().remove_child(oldScene)
	get_tree().set_current_scene(game)
	
	get_tree().get_root().get_node("Player_Lobby").hide()
#	get_tree().get_root().get_node(game).show()
	players = host_players
	
	var player_instance = load("res://Player.tscn")
	for player_ID in spawns:
		var player_role = 0
		player_role = players[player_ID][2]
			
		var spawn_pos
		
		player_role = int(player_role)
		
		print("Layout", layout)		
		
		if player_role == 0:
			spawn_pos = game.get_node("SpawnPointsRunner/" + str(spawns[player_ID])).position
		else:
			#if defender, we have to make sure our defenders spawn at the right places depending on the layout.
			if layout == 1:
				spawn_pos = game.get_node("SpawnPointsDefender/LayoutA/" + str(spawns[player_ID]%2 +1)).position
			else:
				spawn_pos = game.get_node("SpawnPointsDefender/LayoutB/" + str(spawns[player_ID]%3 +1)).position
		
		#Instantiate spawned player and place its position to spawn_pos
		
		var spawned_player = player_instance.instance()
		spawned_player.set_name(str(player_ID))
		spawned_player.position = spawn_pos
		print(spawn_pos)
		
		
		#Set spawned player name.

		spawned_player.set_player_name(players[player_ID][0])
			
		#Assign player roles for each spawned player. Values are explained in Player.gd
		if player_role == 1:
			spawned_player.playerRole = 1 #horizontal movement allowed.
			spawned_player._set_layers(5)
			if layout != 1 and spawns[player_ID]%3 +1 == 3:
				spawned_player.playerRole = 2 
				if layout == 3:
					spawned_player.playerRole = 3 #Special case. Both movement allowed.
		else:
			spawned_player._set_layers(3)
		
		print(spawned_player.playerRole)
		spawned_player.set_network_master(player_ID)
		game.get_node("Players").add_child(spawned_player)
	if not get_tree().is_network_server():
		print("Peer reached get ready")
		# Tell server we are ready to start.
		rpc_id(1, "peer_is_ready", get_tree().get_network_unique_id()) #1 is just an arbitrary value.
	elif players.size() == 1:
		post_prep_game()
		
remote func post_prep_game():
	print("Post game reached")
	get_tree().set_pause(false)

remote func peer_is_ready(player_ID):
	print("peer ready called")
	if get_tree().is_network_server():
		if not(player_ID in players_ready):
			players_ready.append(player_ID)
		if not(1 in players_ready):
			players_ready.append(1)
		if players_ready.size() == players.size():
			for player in players:
				if player != 1:
					rpc_id(player, "post_prep_game")
			post_prep_game()
	else:
		print("ERROR in peer_ready")

func request_show_game_over(type):
	for player in players:
		if (player != get_tree().get_network_unique_id()):
			rpc_id(player, "call_game_over", type)
remote func call_game_over(type):
	emit_signal("show_game_over", type)
