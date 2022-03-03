extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerNo := 0
var playAreaLayout := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody2D/CollisionShape2D/GameArea.set_texture(load("res://Assets/PlayArea%s.png" % (String(playAreaLayout)))) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ExitButton_pressed():
	get_tree().quit()
