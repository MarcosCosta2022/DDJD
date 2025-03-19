extends Node2D

@onready var player := $Player
@onready var HUD := $HUD

var score: int = 0
var time_elapsed: float = 0.0  # Time in seconds

var is_security_on = true

# Define a signal to notify when the score changes
signal score_changed(new_score)
signal change_camera_state(active)

var timer: Timer

var is_game_over = false

var picked_notes = 0

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
	
func _on_timer_timeout() -> void:
	# Increment the time elapsed by 1 second
	time_elapsed += 1.0
	
	# Update the time on the HUD
	HUD.update_time(time_elapsed)
	
func get_player():
	return player
	
func game_over()->void:
	# shows the game over screen
	HUD.show_game_over_screen()
	stop_game()
	
func game_win():
	# show the game win screen
	var time_limit = 120
	var final_score = picked_notes * 10 + 3 * max(0, int(120-time_elapsed))
	HUD.show_game_win_screen(final_score)
	stop_game()
	
func stop_game():
	is_game_over = true
	# stop the timer
	timer.stop()
	
func toggle_security():
	is_security_on = not is_security_on
	change_camera_state.emit(is_security_on)
	
func pick_note():
	picked_notes += 1
	HUD.update_lecture_notes_visibility(picked_notes)
