extends Node2D

@onready var it = $Interactable

@export var game : Node2D
@export var preview : Control

var reading_note = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not game:
		game = get_tree().root.get_child(0) as Node2D
	
	it.interacted.connect(read_note)
	preview.visible = false  # Ensure it's hidden initially

func _process(delta: float) -> void:
	if reading_note and Input.get_axis("ui_left", "ui_right") != 0:
		# Moved left or right then stop reading
		stop_reading()

func stop_reading():
	reading_note = false
	preview.visible = false

func read_note():
	if reading_note:
		stop_reading()
		return
	
	reading_note = true
	preview.visible = true
