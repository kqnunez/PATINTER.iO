extends KinematicBody2D


# Declare member variables here. Examples:
var speed = 400  # speed in pixels/sec #Adjust when needed
var velocity = Vector2.ZERO
var playerRole = "Vertical Defender"
var playerName = "Player"
var stamina = 100 #Adjust when needed

# Called when the node enters the scene tree for the first time.
func _ready():
	set_safe_margin(0.3) # Replace with function body. #Minimizes jittering
	get_node("../StaminaLabel").set_text(str(stamina))

#Arrow keys to run
#Based on: http://kidscancode.org/godot_recipes/2d/topdown_movement/
func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed('ui_up') and playerRole != "Horizontal Defender": #Horizontal defender cannot move up and down
		velocity.y -= 1
	if Input.is_action_pressed('ui_down') and playerRole != "Horizontal Defender":
		velocity.y += 1
	if Input.is_action_pressed('ui_right') and playerRole != "Vertical Defender": #Vertical defender cannot move left and right
		velocity.x += 1
	if Input.is_action_pressed('ui_left') and playerRole != "Vertical Defender":
		velocity.x -= 1
		
	# Make sure diagonal movement isn't faster
	velocity = velocity.normalized() * speed
	
	#Alt+arrow keys to sprint; ui_alt defined as alt key in Project Settings
	if Input.is_action_pressed('ui_alt'):
		if stamina > 0 and (Input.is_action_pressed('ui_up') or Input.is_action_pressed('ui_down') or Input.is_action_pressed('ui_right') or Input.is_action_pressed('ui_left')):
			velocity = 2 * velocity #Adjust constant when needed
		else: #Stop sprinting when no stamina
			velocity = Vector2.ZERO
			
	velocity = move_and_slide(velocity)
	
	#When sprinting, only decrease stamina if player actually moved (prevents stamina wastage when running against wall)
	if velocity != Vector2.ZERO and Input.is_action_pressed('ui_alt'):
		stamina -= 1
		get_node("../StaminaLabel").set_text(str(stamina))

func _physics_process(_delta):
	get_input()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
