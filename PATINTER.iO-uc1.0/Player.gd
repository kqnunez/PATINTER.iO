extends KinematicBody2D


# Declare member variables here. Examples:
var speed = 400  # speed in pixels/sec #Adjust when needed
var velocity = Vector2.ZERO
var role = "Runner"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#Arrow keys to run
#Based on: http://kidscancode.org/godot_recipes/2d/topdown_movement/
func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed('ui_up') and role != "Horizontal Defender": #Horizontal defender cannot move up and down
		velocity.y -= 1
	if Input.is_action_pressed('ui_down') and role != "Horizontal Defender":
		velocity.y += 1
	if Input.is_action_pressed('ui_right') and role != "Vertical Defender": #Vertical defender cannot move left and right
		velocity.x += 1
	if Input.is_action_pressed('ui_left') and role != "Vertical Defender":
		velocity.x -= 1
		
	# Make sure diagonal movement isn't faster
	velocity = velocity.normalized() * speed

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
