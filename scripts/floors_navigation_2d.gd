extends Node2D

@onready var floor0 = $Floor0Navigation
@onready var floor1= $Floor1Navigation
@onready var floor2 = $Floor2Navigation
@onready var floor3 = $Floor3Navigation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func location_in_floor(position):
	# takes a 2d vector poosition and checks which floor if any the position is in
	pass
