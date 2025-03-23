extends CharacterBody2D

@export var SPEED = 180.0
@export var JUMP_VELOCITY = -400.0
@export var gravity = 1000

@onready var ap = $AnimationPlayer
@onready var sp = $Sprite2D
@onready var centerMarker = $CollisionShape2D/Center

@onready var thoughts = $Thoughts

# speed boost attributes
var speed_boost_start_time : float = 0
var speed_boost_activated : bool = false 
var speed_boost_duration : float = 10 # lasts for 10 seconds
var speed_boost_effect : float = 1.2 # increases speed by 50 percent

var invisibility_activated := false
var invisibility_duration := 10.0
var invisibility_start_time := 0
var has_invisibility_power := false # if he has invisibility item that can be used when the player wants

var points = 0;

var has_keycard = false
var has_coin = false

func _ready():
	set_process_priority(1)  # Ensure the guard updates after other nodes


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += Vector2(0,gravity) * delta
		
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	var is_game_over = get_parent().is_game_over
	var direction := Input.get_axis("ui_left", "ui_right")
	if not is_game_over: # if game is not over allow movement
		if direction:
			if speed_boost_activated:
				velocity.x = direction * SPEED * speed_boost_effect
			else : velocity.x = direction * SPEED
			switch_direction(direction);
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		direction = 0
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	update_animations(direction)
	
	if(speed_boost_activated):
		update_speed_boost()
	
	if has_invisibility_power and Input.is_action_just_pressed("use"):
		print("Using invisibility")
		activate_invisibility()
	
	if(invisibility_activated):
		update_invisibility()
	
	
func update_animations(horizontal_direction):
	if is_on_floor():
		if horizontal_direction ==0:
			ap.play("idle")
		else:
			ap.play("run")
	else:
		if velocity.y < 0:
			ap.play("jump")
		elif velocity.y > 0:
			ap.play("fall")
		
func switch_direction(horizontal_direction):
	sp.flip_h = (horizontal_direction == -1)
	if (horizontal_direction == 1):
		sp.position.x = 4
	elif (horizontal_direction == -1):
		sp.position.x = -6
		
# Function to get the center of the collision shape
func get_center() -> Vector2:
	return centerMarker.global_position

func drink_coffee():
	# activate speed boost
	speed_boost_start_time = Time.get_ticks_msec()
	speed_boost_activated = true
	
	#show speed boost icon in the HUD
	var hud = get_parent().get_node("HUD")
	if hud:
		hud.show_speed_boost()
	

func update_speed_boost():
	var current_time = Time.get_ticks_msec()
	var elapsed_time = (current_time - speed_boost_start_time)/1000
	if(elapsed_time >= speed_boost_duration): # speed boost ends
		speed_boost_activated = false 
		var hud = get_parent().get_node("HUD")
		if hud:
			hud.hide_speed_boost()

func pick_coat():
	has_invisibility_power = true
	
	#show the coat over the player's head
	var hud = get_parent().get_node("HUD")
	if hud:
		hud.show_coat_icon()

func activate_invisibility():
	has_invisibility_power = false
	invisibility_activated = true
	invisibility_start_time = Time.get_ticks_msec()
	var hud = get_parent().get_node("HUD")
	sp.modulate.a = 0.2
	if hud:
		hud.hide_coat_icon()
		hud.show_invisible_icon()


func update_invisibility():
	var current_time = Time.get_ticks_msec()
	var elapsed_time = float (current_time - invisibility_start_time)/1000
	var range = 100 - min(100, elapsed_time/invisibility_duration * 100)
	var hud = get_parent().get_node("HUD")
	if hud:
		hud.update_invisible_icon(range)
	if(elapsed_time >= invisibility_duration): # invisibility ends
		sp.modulate.a = 1
		invisibility_activated = false 

			
func get_thoughts():
	return thoughts
	
func add_keycard():
	has_keycard = true
	# add keycard to the HUD
	var hud = get_parent().get_node("HUD")
	if hud:
		hud.show_key_card_icon(true)
		
func add_coin():
	has_coin = true
	# add keycard to the HUD
	var hud = get_parent().get_node("HUD")
	if hud:
		hud.show_coin_icon(true)
	
	
	
