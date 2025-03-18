extends Node2D

@onready var it = $Interactable
@export var game : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# get game
	if not game:
		game = get_parent()
	
	it.interacted.connect(toggle_security)

func toggle_security()-> void:
	game.toggle_security()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
