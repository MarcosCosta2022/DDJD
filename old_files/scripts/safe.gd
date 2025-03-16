extends Node2D

@onready var interactable = $Interactable

@onready var game : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interacted.connect(grab_exams)  # Connect signal
	
	# Get the root node of the scene
	game = get_tree().root.get_child(0)  # Assuming the root node is your main game scene

func grab_exams()->void:
	game.game_win()
	
