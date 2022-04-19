class_name SaveLoadGame extends Resource


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SAVE_DIR = "user://saves/"
var PLAYER_DIR = "player/"
var GAME_DIR = "game/"
var savePathPlayer = SAVE_DIR + PLAYER_DIR + "playerSave.dat"
var savePathGame = SAVE_DIR + GAME_DIR + "gameSave.dat"
var data = {}

func saveData(dataType:="player"):
	var dir = Directory.new()
	var dir2
	if dataType == "player":
		dir2 = PLAYER_DIR
	elif dataType == "game":
		dir2 = GAME_DIR
	else:
		print("Error: Wrong dataType requested in saving.")
		return
		
	if !dir.dir_exists(SAVE_DIR + dir2):
		dir.make_dir_recursive(SAVE_DIR + dir2)
	
	var save_data = File.new()
	if dataType == "player":
		var error = save_data.open(savePathPlayer, File.WRITE)
		if error == OK:
			save_data.store_var(data)
			save_data.close()
			print("Player Data Saved!")
	elif dataType == "game":
		var error = save_data.open(savePathGame, File.WRITE)
		if error == OK:
			save_data.store_var(data)
			save_data.close()
			print("Game Data Saved!")
	else:
		print("Error: Wrong dataType requested for saving.")

func loadData(dataType:="player"):
	var save_game = File.new()
	if dataType == "player":
		if save_game.file_exists(savePathPlayer):
			var error = save_game.open(savePathPlayer, File.READ)
			if error == OK:
				var data = save_game.get_var()
				save_game.close()
				self.data = data
				print("Player History loaded!")
		else:
			print("No Player save file yet.")
	elif dataType == "game":
		if save_game.file_exists(savePathGame):
			var error = save_game.open(savePathGame, File.READ)
			if error == OK:
				var data = save_game.get_var()
				save_game.close()
				self.data = data
				print("Game History loaded!")
		else:
			print("No Game save file yet.")
	else:
		print("Error: Wrong dataType requested for loading.")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
