extends Node2D

@onready var player := $Player
@onready var HUD := $HUD
@onready var hacking_mini_game = $HackingMiniGame

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
	
	var hidden_note_scene = load("res://scenes/hidden_note.tscn")
	var hiding_spots = get_hiding_spots()
	print("Hiding_spots:")
	print(hiding_spots.size())
	hiding_spots.shuffle() 
	hiding_spots = hiding_spots.slice(0, 3) # Choose 3 random hiding spots
	for spot in hiding_spots:
		var hidden_note = hidden_note_scene.instantiate()
		spot.add_child(hidden_note)
	
func _process(delta: float) -> void:
	HUD.pre_process(delta)
	
	if Input.is_key_pressed(KEY_R):
		restart()

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
	close_mini_hacking_game()
	stop_game()
	
func game_win():
	var lower_time_limit = 40 # if completed under 40 seconds they get full points
	var upper_time_limit = 300 # if they take more than 300 seconds they get no points 
	var maximum_points_for_time = 300
	var points_for_time = max(0, ((upper_time_limit - time_elapsed) / (upper_time_limit - lower_time_limit)) * maximum_points_for_time)
	
	var points_per_note = 60
	var points_for_notes = picked_notes * points_per_note
	
	var final_score = round(points_for_notes + points_for_time)  # Round the final score
	
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
	
func getHUD():
	return HUD
	
func open_mini_hacking_game():
	hacking_mini_game.visible = true
	hacking_mini_game.open = true
	# stop player movement
	player.can_move = false
	
func close_mini_hacking_game():
	hacking_mini_game.visible = false
	hacking_mini_game.open = false
	# stop player movement
	player.can_move = true
	
func get_hiding_spots():
	var nodes = []
	for child in get_children():
		if child.name.begins_with("Bins") or child.name.begins_with("Bookshelf"):
			nodes.append(child)
	return nodes
	
func restart():
	# Called when the user clicks on the restart button and it loads the current scene again
	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()  # Reloads the current scene
