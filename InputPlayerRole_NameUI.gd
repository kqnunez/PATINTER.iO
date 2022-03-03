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
	print("Received: ", playerNo) # Replace with function body.
	
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
	playerName = $nameRoleMenu/verticalCenter/sideMargins/menuButtons/HBoxContainer/inputControls/playerNameInput.get_text()
