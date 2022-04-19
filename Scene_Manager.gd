extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#Based on: https://docs.godotengine.org/en/3.0/getting_started/step_by_step/singletons_autoload.html#custom-scene-switcher
#https://godotengine.org/qa/24773/how-to-load-and-change-scenes
func passPlayerNoLayout(oldScene, newScenePath):
	var newScene = load(newScenePath).instance()
	newScene.playerName = str(oldScene.playerName)
	
	#If the old scene is the scene right before the game screen, pass player role and player name too.
	#Might be changed to pass list of player roles and names once multiplayer is implemented
	if "playerNo" in oldScene and "playAreaLayout" in oldScene:
		newScene.playerNo = int(oldScene.playerNo)
		newScene.playAreaLayout = int(oldScene.playAreaLayout)
		
	if "playerRole" in oldScene:
		newScene.playerRole = int(oldScene.playerRole)
		
	if "lobbyName" in oldScene and "lobbyName" in newScene:
		newScene.lobbyName = str(oldScene.lobbyName)
		
	get_tree().get_root().remove_child(oldScene)
	get_tree().get_root().add_child(newScene)
	get_tree().set_current_scene(newScene)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
