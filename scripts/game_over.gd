extends Control

@onready var restart_button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the button's pressed signal to the restart_scene function
	restart_button.pressed.connect(_on_restart_button_pressed)

# Called when the user clicks on the restart button
func _on_restart_button_pressed():
	restart_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func restart_scene():
	# Called when the user clicks on the restart button and it loads the current scene again
	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()  # Reloads the current scene
