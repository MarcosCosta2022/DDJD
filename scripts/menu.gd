extends Node2D

@export var level_1_scene_path := "res://scenes/level_1.tscn"

@onready var invisible_label = $Control/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	invisible_label.visible = true  # Make sure it's visible
	invisible_label.self_modulate.a = 1  # Ensure full opacity
	invisible_label.modulate.a = 1  # Reset modulate alpha


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	#Load the first level
	var level = load(level_1_scene_path)
	if level:
		get_tree().change_scene_to_packed(level)
	else:
		print("Error: Failed to load level.")


func _on_exit_button_pressed() -> void:
	get_tree().quit()  # Quits the game
