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
	newScene.playerNo = int(oldScene.playerNo)
	newScene.playAreaLayout = int(oldScene.playAreaLayout)
	
	get_tree().get_root().remove_child(oldScene)
	get_tree().get_root().add_child(newScene)
	get_tree().set_current_scene(newScene)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
