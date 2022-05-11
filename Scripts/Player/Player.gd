extends KinematicBody2D


# Declare member variables here. Examples:
var speed = 400  # speed in pixels/sec #Adjust when needed
puppet var player_velocity = Vector2.ZERO
puppet var player_position = Vector2.ZERO
puppet var player_stamina = 100
#PlayerRole is a 3-bit value:
#1st Bit: Is Runner?
#2nd Bit: Can Defend Vertically?
#3rd Bit: Can Defend Horizontally?
#Ex. 011 is a Defender that can move both up and down. 100 is a runner (default).
var playerRole = 4 

var playerName = "Player"
var stamina = 100 #Adjust when needed
var isGameOver = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_safe_margin(0.3) # Replace with function body. #Minimizes jittering
	get_node("/root/Game/GameDock/Stamina/StamCenter/InstrList/StamNumber").set_text(str(stamina))

#Arrow keys to run
#Based on: http://kidscancode.org/godot_recipes/2d/topdown_movement/
func get_input():
	var velocity = Vector2.ZERO
	if not isGameOver:
		if is_network_master():
			if Input.is_action_pressed('ui_up') and playerRole > 1: #Horizontal defender cannot move up and down
				velocity.y -= 1
			if Input.is_action_pressed('ui_down') and playerRole > 1:
				velocity.y += 1
			if Input.is_action_pressed('ui_right') and playerRole != 2: #Vertical defender cannot move left and right
				velocity.x += 1
			if Input.is_action_pressed('ui_left') and playerRole != 2:
				velocity.x -= 1
			
			# Make sure diagonal movement isn't faster
			velocity = velocity.normalized() * speed
		
			#Alt+arrow keys to sprint; ui_alt defined as alt key in Project Settings
			if Input.is_action_pressed('ui_alt'):
				if stamina > 0 and (Input.is_action_pressed('ui_up') or Input.is_action_pressed('ui_down') or Input.is_action_pressed('ui_right') or Input.is_action_pressed('ui_left')):
					velocity = 2 * velocity #Adjust constant when needed
				else: #Stop sprinting when no stamina
					velocity = Vector2.ZERO
				
			#velocity = move_and_slide(velocity)
		
			#When sprinting, only decrease stamina if player actually moved (prevents stamina wastage when running against wall)
			if velocity != Vector2.ZERO and Input.is_action_pressed('ui_alt'):
				stamina -= 1
				get_node("/root/Game/GameDock/Stamina/StamCenter/InstrList/StamNumber").set_text(str(stamina))
				get_node("/root/Game/GameDock/Stamina/StamCenter/InstrList/StamNumber").set_text(str(stamina))
				
			rset("player_position", position)
			rset("player_velocity", velocity)
			rset("player_stamina", stamina)
		else:
			#position = player_position
			position = position
			#velocity = player_velocity
		
		move_and_slide(velocity)
		
		
		if not is_network_master():
			player_position = position
			player_stamina = stamina
			

func _physics_process(_delta):
	get_input()
	
	var collision = move_and_collide(player_velocity*_delta)
	if collision and "playerRole" in collision.collider: #If player bumped with another player:
		var other_player_role = collision.collider.playerRole
		if other_player_role == playerRole or (other_player_role < 4 and playerRole < 4): #If both runners/both defenders, do nothing
			print("OTHER ROLE STUFF")
			pass
		elif other_player_role < 4 and playerRole == 4:
			rpc("remove_player", self)
			get_node("/root/Game").showGameOverScreen(3)
		else:
			get_node("/root/Game").showGameOverScreen(3)
	
remotesync func remove_player(player_to_hide):
	print("removing", get_tree().get_network_unique_id())
	self.set_physics_process(false)
	self.hide() #pass
	NetworkScript.request_show_game_over(3)

func set_player_name(name):
	$Name.text = name
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
