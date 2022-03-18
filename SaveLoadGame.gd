class_name SaveLoadGame extends Resource


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SAVE_DIR = "user://saves/"
var savePathPlayer = SAVE_DIR + "playerSave.dat"
var savePathGame = SAVE_DIR + "gameSave.dat"
var data = {}

func saveData(isPlayer:=true):
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var save_data = File.new()
	if isPlayer:
		var error = save_data.open(savePathPlayer, File.WRITE)
		if error == OK:
			save_data.store_var(data)
			save_data.close()
			print("Player Data Saved!")
	else:
		var error = save_data.open(savePathGame, File.WRITE)
		if error == OK:
			save_data.store_var(data)
			save_data.close()
			print("Game Data Saved!")

func loadData(isPlayer:=true):
	var save_game = File.new()
	if isPlayer:
		if save_game.file_exists(savePathPlayer):
			var error = save_game.open(savePathPlayer, File.READ)
			if error == OK:
				var data = save_game.get_var()
				save_game.close()
				print("Player History loaded!")
				print(data)
		else:
			print("No Player save file yet.")
	else:
		if save_game.file_exists(savePathGame):
			var error = save_game.open(savePathGame, File.READ)
			if error == OK:
				var data = save_game.get_var()
				save_game.close()
				print("Game History loaded!")
				print(data)
		else:
			print("No Game save file yet.")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
