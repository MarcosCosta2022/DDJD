extends Node2D

@onready var player = $Player
@onready var HUD = $Control

var score: int = 0
var time_elapsed: float = 0.0  # Time in seconds

# Define a signal to notify when the score changes
signal score_changed(new_score)

var timer: Timer

func _ready() -> void:
	# Initialize the timer node if it doesn't already exist
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0  # 1 second interval for the timer
	timer.autostart = true  # Start the timer automatically
	
	# Connect the timeout signal to the method
	timer.timeout.connect(_on_timer_timeout)
	
	# Start the timer manually if autostart didn't work as expected
	timer.start()
	
	# Initialize the time on HUD
	HUD.update_time(time_elapsed)

func increase_score(amount: int):
	score += amount
	score_changed.emit(score)  # Emit the new score
	
func drink_coffe():
	print("Increased speed")
	
func _on_timer_timeout() -> void:
	# Increment the time elapsed by 1 second
	time_elapsed += 1.0
	
	# Update the time on the HUD
	HUD.update_time(time_elapsed)
