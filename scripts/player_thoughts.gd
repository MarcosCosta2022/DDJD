extends Control

@onready var centerContainer = $CenterContainer
var current_label: Label = null  # Store the current label
var timer: Timer = null  # Store the timer

# Function to display text as if the character is saying something
func say(text: String, duration: float = 2.0, size: float = 20) -> void:
	# Remove the existing label if there is one
	if current_label:
		current_label.queue_free()
		current_label = null  # Explicitly set it to null after freeing

	# Remove the existing timer if there is one
	if timer:
		timer.stop()  # Stop the existing timer
		timer.queue_free()  # Free the existing timer
		timer = null  # Explicitly set timer to null

	# Create new label
	current_label = Label.new()
	current_label.text = text
	current_label.add_theme_font_size_override("font_size", size)  # Adjust font size
	current_label.add_theme_color_override("font_color", Color(1,1,1))  # Set text color (white)
	current_label.add_theme_color_override("font_outline_color", Color(0,0,0))  # Set outline color (black)
	current_label.add_theme_constant_override("outline_size", 8)  # Set outline size
	current_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER  # Center text horizontally
	current_label.set_anchors_preset(Control.PRESET_CENTER)  # Center the label
	current_label.scale = Vector2(0.1, 0.1)  # Rescale the label to 50% of its original size
	centerContainer.add_child(current_label)
	
	# Create a new timer to remove the label after the duration
	timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(func():
		# Only call queue_free if current_label is not null
		if current_label:
			current_label.queue_free()
			current_label = null
		# Ensure that the timer is freed when it's done
		timer.queue_free()
		timer = null
	)
