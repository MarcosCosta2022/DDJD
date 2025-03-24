extends Node2D

@onready var sequence_container = $Sequence
@onready var highlight_rect = $CenterContainer
@onready var timer = $Timer
@onready var time_label = $TimeLabel

@onready var arrow_sprites = {
	"left": $Pressets/leftArrow,
	"right": $Pressets/rightArrow,
	"up": $Pressets/upArrow,
	"down": $Pressets/downArrow
}

var input_sequence = []
var player_input = []
var sequence_length = 6  # Change this for difficulty
var is_active = false
var key_spacing = 100  # Adjust spacing to fit the layout
var time = 8

var displayed_sprites = []  # Store references to the displayed sprites

var running = false

signal won
signal lost

func _ready() -> void:
	is_active = false
	running = false
	
func start():
	clear_game()
	_generate_sequence()
	_display_sequence()
	timer.start(time)  # 5 seconds to complete
	running = true
	is_active = true
	
	
func clear_game():
	# Stop the timer
	timer.stop()
	
	# Clear the input sequences
	input_sequence.clear()
	player_input.clear()
	
	# Ensure displayed sprites are properly removed
	for sprite in displayed_sprites:
		if sprite != null and sprite.is_inside_tree():
			sprite.queue_free()
	displayed_sprites.clear()  # Clear the reference list

	# Reset the highlight position
	_update_highlight(0)
	
	# Reset UI elements
	time_label.text = "00:00"
	time_label.add_theme_color_override("font_color", Color(1, 1, 1))  # Default white
	
	# Reset game state
	is_active = false
	running = false

func _process(_delta: float) -> void:
	if not running:
		return
	
	if is_active:
		_check_input()
		
	# Update time label in SS:MM format (seconds:milliseconds)
	var time_left = max(0, timer.time_left)
	var seconds = floor(time_left)
	var milliseconds = floor((time_left - seconds) * 100)  # Convert fraction to milliseconds
	
	time_label.text = "%02d:%02d" % [seconds, milliseconds]
	
	# Change color to red when there's only 1 second left
	if time_left <= 1:
		time_label.add_theme_color_override("font_color", Color(1, 0, 0))  # Red
	else:
		time_label.add_theme_color_override("font_color", Color(1, 1, 1))  # White (default)

func _generate_sequence():
	var directions = ["left", "right", "up", "down"]
	input_sequence.clear()
	for i in range(sequence_length):
		input_sequence.append(directions[randi() % directions.size()])

func _display_sequence():
	# Clear any previous sequence
	for child in sequence_container.get_children():
		child.queue_free()

	var start_x = -((sequence_length - 1) * key_spacing) / 2  # Centering formula

	for direction in input_sequence:
		var sprite = arrow_sprites[direction].duplicate()  # Duplicate preset sprite
		sprite.position = Vector2(start_x, 0)  # Place each sprite in a row
		start_x += key_spacing  # Move to the right for the next key
		sequence_container.add_child(sprite)  # Add sprite to sequence container
		displayed_sprites.append(sprite)  # Store the sprite reference
	# Place the highlight panel behind the first key
	_update_highlight(0)

func _update_highlight(index: int):
	if index < sequence_container.get_child_count():
		var target_sprite = sequence_container.get_child(index)
		
		# Ensure highlight_rect is not null and is still in the scene tree
		if highlight_rect != null:
			if highlight_rect.is_inside_tree():
				highlight_rect.position = target_sprite.position
			else:
				print("Highlight rect is not in the scene tree!")
		else:
			print("Highlight rect is null!")

func _check_input():
	for action in ["ui_left", "ui_right", "ui_up", "ui_down"]:
		if Input.is_action_just_pressed(action):
			_register_input(action.replace("ui_", ""))
			break

func _register_input(direction: String):
	if input_sequence[player_input.size()] == direction:
		player_input.append(direction)
		_update_highlight(player_input.size())  # Move highlight to next key
		_update_pressed_keys()  # Update the modulate of pressed keys
		if player_input.size() == input_sequence.size():
			_win()
	else:
		_fail()
		
func _update_pressed_keys():
	# Update the modulate of the keys that have been pressed
	for i in range(player_input.size()):
		if i < displayed_sprites.size():
			var sprite = displayed_sprites[i]
			if sprite != null and sprite.is_inside_tree():  # Check if sprite is still valid
				sprite.modulate = Color(0.5, 0.5, 0.5, 1)  # Darken the sprite
func _win():
	is_active = false
	timer.stop()
	won.emit()

func _fail():
	is_active = false
	timer.stop()
	lost.emit()

func _on_timer_timeout() -> void:
	_fail()
