extends CharacterBody2D

# get the other scripts
@onready var movement = $GuardMovement
@onready var alertness_script = $GuardAlertness
@onready var animation_script = $GuardAnimation

@export var speed := 200.0
@export var gravity := 500.0  # Adjust as needed
@export var patrol_path: NodePath  # Assign a Path2D for patrol
@export var attack_range := 100.0  # Distance to start attacking
@export var game : Node2D
@export var patrol_points: Array[NodePath]  # Assign two Marker2D nodes
@export var wait_time := 1.5  # Time to wait at each patrol point

var state = "patrolling"
var last_seen_position = Vector2.ZERO
var attacking = false

@onready var nav_agent = $NavigationAgent2D
@onready var raycast = $RayCast2D
@onready var patrol_follow = get_node(patrol_path) if patrol_path else null

@onready var sp = $AnimatedSprite2D
@onready var attack_area = $AttackArea
@onready var alicon = $AlertnessIcon

@export var hud : Control	


# Alertness mechanics
var alertness: float = 0.0  # Ranges from 0 to 100
var alertness_rate: float = 100.0 / 1.5  # 100 over 1.5 seconds (adjust as needed)
var alertness_decrease_rate: float = 100.0 / 3.0  # 100 over 3 seconds (adjust as needed)
var last_seen_time: float = -1.0  # Time when the player was last seen
var time_since_lost_sight: float = 0.0  # Tracks how long the player has been out of sight

var patrol_targets = []  # List of patrol points
var current_target_index = 0
var waiting = false
var wait_timer = 0.0  # Timer to handle waiting at patrol points

var surprised = false  # Track if the guard is surprised
var surprise_timer = 0.0  # Timer for the pause

func _ready():
	if patrol_points.size() == 2:
		patrol_targets = [get_node(patrol_points[0]).global_position, get_node(patrol_points[1]).global_position]
	
	sp.animation_finished.connect(_on_animation_finished)

	if not game:
		game = get_tree().root.get_child(0)  # Assuming the root node is your main game scene
		
	if game and not hud:
		hud = game.get_node("HUD")

func _process(delta):
	var is_game_over = game.is_game_over
	if(is_game_over): 
		update_animation(0)
		return
	
	match state:
		"patrolling":
			patrol(delta)
		"chasing":
			chase_player()
			
	alicon.update_alertness_display(alertness)

func patrol(delta):
	if waiting:
		wait_timer -= delta
		if wait_timer <= 0:
			waiting = false
			current_target_index = (current_target_index + 1) % 2  # Switch to the next point
		return

	var target_position = patrol_targets[current_target_index]
	move_towards(target_position)

	if global_position.distance_to(target_position) < 10:  # Close enough to stop
		velocity = Vector2.ZERO
		update_animation(0)  # Ensure the guard plays "idle" animation
		waiting = true
		wait_timer = wait_time

func chase_player():
	var distance_to_player = global_position.distance_to(last_seen_position)
	
	if (distance_to_player < 60):
		velocity = Vector2.ZERO
		update_animation(0)  # Ensure the guard plays "idle" animation
	else:
		move_towards(last_seen_position)
	
func attack():
	attacking = true
	sp.play("attack")
	velocity = Vector2.ZERO  # Stop movement
			
func hit_player():
	# Check if player is inside the attack area
	for body in attack_area.get_overlapping_bodies():
		if body is Player:
			print("Player hit! Game Over")
			game.game_over()

func move_towards(target):
	
	nav_agent.target_position = target
	var next_pos = nav_agent.get_next_path_position()
	var move_direction = (next_pos - global_position).normalized()

	if move_direction.length() > 0.1:
		velocity.x = move_direction.x * speed  # Only modify horizontal movement
	else:
		velocity = Vector2.ZERO
		update_animation(0)  # Play idle animation when stopped

	# Update animation and flip
	update_animation(move_direction.x)


func update_animation(direction_x):

	if abs(direction_x) > 0.1:  # Moving
		if sp.animation != "run":
			sp.play("run")
		var facing_left = direction_x < 0
		sp.flip_h = facing_left  # Flip sprite
		
		# Flip RayCast2D
		var raycast_offset = abs(raycast.target_position.x)
		raycast.target_position.x = -raycast_offset if facing_left else raycast_offset
	else:  # Stopped
		if sp.animation != "idle":
			sp.play("idle")
			
func _on_animation_finished():
	if sp.animation == "attack":
		attacking = false  # Resume movement after attack
		hit_player()
		# Move the guard slightly forward after attacking
		var shift_amount = 30 if not sp.flip_h else -30
		var collision = move_and_collide(Vector2(shift_amount, 0))

		# If collision happens, prevent moving further into obstacles
		if collision:
			print("Blocked while moving forward after attack.")
		state = "chasing"

func _physics_process(delta):
	# Apply gravity
	velocity.y += gravity * delta
	
	var is_game_over = game.is_game_over
	if(is_game_over): return
	# Check for the player
	if is_player_visible():
		react(delta)  # Increase alertness, start chasing if necessary
		last_seen_time = Time.get_ticks_msec() / 1000.0
		time_since_lost_sight = 0.0
	else:
		handle_alertness_decay(delta)  # Gradually reduce alertness
	
	# Apply movement normally if not surprised
	move_and_slide()

func handle_alertness_decay(delta):
	# If the player was recently seen, track time since they were lost
	if last_seen_time > 0:
		time_since_lost_sight += delta
		# After 3 seconds of losing sight, start reducing alertness
		if time_since_lost_sight > 3.0:
			alertness = max(0, alertness - delta * alertness_decrease_rate)  # Decrease alertness gradually
			if alertness == 0:
				continue_patrolling()

func continue_patrolling():
	last_seen_time = 0  # Reset tracking to return to patrol mode
	state = "patrolling"

func is_player_visible():
	if raycast.is_colliding():
		var obj = raycast.get_collider()
		if obj is Player:
			last_seen_position = obj.global_position
			return true
	return false
	
func react(delta):
	# if wasnt chasing, then start
	if(state == "patrolling"):start_chasing()
	
	alertness = min(alertness + alertness_rate * delta, 100)  # Increase alertness while in sight
	
	if hud:
		hud.seeing_player()
		
	if alertness == 100:
		found_player()
	
func found_player():
	game.game_over()
			
func start_chasing():
	print("Chasing ")
	state = "chasing"
	
