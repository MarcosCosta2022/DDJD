extends CharacterBody2D

@export var speed := 200.0
@export var gravity := 500.0  # Adjust as needed
@export var patrol_path: NodePath  # Assign a Path2D for patrol
@export var attack_range := 100.0  # Distance to start attacking
@export var game : Node2D

var state = "patrolling"
var last_seen_position = Vector2.ZERO
var attacking = false

@onready var nav_agent = $NavigationAgent2D
@onready var raycast = $RayCast2D
@onready var patrol_follow = get_node(patrol_path) if patrol_path else null

@onready var sp = $AnimatedSprite2D
@onready var attack_area = $AttackArea

@export var hud : Control	

# Alertness mechanics
var alertness: float = 0.0  # Ranges from 0 to 100
var alertness_rate: float = 100.0 / 1.5  # 100 over 1.5 seconds (adjust as needed)
var alertness_decrease_rate: float = 100.0 / 3.0  # 100 over 3 seconds (adjust as needed)
var last_seen_time: float = -1.0  # Time when the player was last seen
var time_since_lost_sight: float = 0.0  # Tracks how long the player has been out of sight

func _ready():
	if patrol_follow:
		patrol_follow.progress = 0  # Start patrol from the beginning
		
	sp.animation_finished.connect(_on_animation_finished)
	
	if not game:
		#then serach tree
		game = get_tree().root.get_child(0)  # Assuming the root node is your main game scene
		
	if game and not hud:
		hud = game.get_node("HUD")


func _process(delta):
	var is_game_over = game.is_game_over
	
	if(is_game_over): return
	
	match state:
		"patrolling":
			patrol()
		"chasing":
			chase_player()

func patrol():
	if patrol_follow:
		patrol_follow.progress += speed * 0.05  # Adjust speed as needed
		var target_position = patrol_follow.global_position
		move_towards(target_position)

func chase_player():
	if attacking:
		return  # Stop moving while attacking
		
	var distance_to_player = global_position.distance_to(last_seen_position)

	if distance_to_player < attack_range:
		attack()
		return

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
	if attacking:
		return  # Stop moving while attacking
	
	nav_agent.target_position = target
	var next_pos = nav_agent.get_next_path_position()
	var move_direction = (next_pos - global_position).normalized()
	velocity.x = move_direction.x * speed  # Only modify horizontal movement
	
	# Update animation and flip
	update_animation(move_direction.x)

func update_animation(direction_x):
	if attacking:
		return  # Don't change animation while attacking
	if abs(direction_x) > 0.1:  # Moving
		if sp.animation != "run":
			sp.play("run")
		sp.flip_h = direction_x < 0  # Flip when moving left
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
	
	# Move normally
	move_and_slide()
	
	# Check for the player
	if is_player_visible():
		react(delta)
		last_seen_time = Time.get_ticks_msec() / 1000.0  # Store the last seen time in seconds
		time_since_lost_sight = 0.0  # Reset lost sight timer
	else:
		if last_seen_time > 0:
			var current_time = Time.get_ticks_msec() / 1000.0
			time_since_lost_sight = current_time - last_seen_time
			if time_since_lost_sight >= 3.0:  # Wait 3 seconds before decreasing alertness
				alertness = max(alertness - alertness_decrease_rate * delta, 0)
			
	# Trigger game over if alertness reaches 100
	if alertness >= 100:
		game.game_over()
			
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
	
			
func start_chasing():
	print("Chasing ")
	state = "chasing"
	
