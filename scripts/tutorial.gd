extends Control

@onready var it = $Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	it.interacted.connect(remove_tutorial)

func remove_tutorial():
	queue_free()
