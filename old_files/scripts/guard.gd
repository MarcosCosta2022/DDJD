extends Node2D

@onready var path = $Path2D/PathFollow2D
@onready var sprite = $Path2D/PathFollow2D/CharacterBody2D/AnimatedSprite2D
@onready var cb = $Path2D/PathFollow2D/CharacterBody2D
@onready var player := get_node("/root/Level1/Player") 
@onready var hud := get_node("/root/Level1/HUD")

@export var speed = 100
@export var wait_time = 2  # Time to wait at the ends


var direction = 1  # 1 means moving forward, -1 means moving backward
var waiting = false
var watchingPlayer = false

# Alertness mechanics
var alertness: float = 0.0  # Ranges from 0 to 100
var alertness_rate: float = 100.0 / 1.5  # 100 over 1.5 seconds (adjust as needed)
var alertness_decrease_rate: float = 100.0 / 3.0  # 100 over 3 seconds (adjust as needed)
var last_seen_time: float = -1.0  # Time when the player was last seen
var time_since_lost_sight: float = 0.0  # Tracks how long the player has been out of sight

var game : Node2D

func _ready() -> void:
	game = get_parent()

func _process(delta: float) -> void:
	if waiting:
		return
	
	var previous_progress = path.progress_ratio
	path.progress += direction * speed * delta
	
	if (direction == 1  and path.progress_ratio < previous_progress) or (direction == -1 and path.progress_ratio > previous_progress):
		path.progress_ratio = direction == 1
		direction *= -1  # Reverse direction
		waiting = true
		await get_tree().create_timer(wait_time).timeout
		waiting = false
		# flip the sprite
		sprite.flip_h = (direction == -1)
		print("Flip_h:", sprite.flip_h, " Direction:", direction)
	
	if checkIfPlayerVisible():
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

func react(delta) -> void:
	alertness = min(alertness + alertness_rate * delta, 100)  # Increase alertness while in sight
	
	if hud:
		hud.seeing_player()
		
	
func checkIfPlayerVisible() -> bool:
	var guard_pos = cb.global_position
	if (direction == 1):
		return abs(guard_pos.y - player.global_position.y) < 5 and guard_pos.x < player.global_position.x and abs(player.global_position.x - guard_pos.x) < 250
	else:
		return abs(guard_pos.y - player.global_position.y) < 5 and guard_pos.x > player.global_position.x and abs(player.global_position.x - guard_pos.x) < 250
