extends Node2D

@export var layerDoor1 := 0
@export var layerDoor2 := 3


@onready var Door1 := $Door1
@onready var Door2 := $Door2

var height := 183

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(layerDoor1 != 3):
		Door1.position.y = layerDoor1 * height
	else: 
		Door1.position.y = layerDoor1 * height + 20
	if(layerDoor2 != 3):
		Door2.position.y = layerDoor2 * height
	else: 
		Door2.position.y = layerDoor2 * height + 24
	
	Door1.setTargetDoor(Door2)
	Door2.setTargetDoor(Door1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
