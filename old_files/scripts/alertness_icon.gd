extends Control

@export var alertness : float = 0

@onready var eye_icon = $Sprite2D
@onready var progress_bar = $CenterContainer/TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_alertness_display(alertness)

func update_alertness_display(alertness):
	self.alertness = alertness
	progress_bar.value = alertness  # Update the circular bar
	self.visible = alertness > 0  # Hide when no alertness
