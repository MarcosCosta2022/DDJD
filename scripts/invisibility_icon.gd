extends Control

var invisibility : float = 100

@onready var eye_icon = $Sprite2D
@onready var progress_bar = $TextureProgressBar

func _ready() -> void:
	pass

func update_invisibility_display(invisibility):
	self.invisibility = invisibility
	progress_bar.value = invisibility  # Update the circular bar
	self.visible = invisibility > 0  # Hide when no alertness
