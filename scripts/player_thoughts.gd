extends Control

@onready var centerContainer = $CenterContainer

# Function to display text as if the character is saying something
func say(text: String, duration: float = 2.0, size : float = 12) -> void:
	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)  # Adjust font size if needed
	label.add_theme_color_override("font_color", Color(1,1,1))  # Set text color (white)
	label.set_anchors_preset(Control.PRESET_CENTER)  # Center the label
	centerContainer.add_child(label)
	
	# Create a timer to remove the label after the duration
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(func():
		label.queue_free()
		timer.queue_free()
	)
