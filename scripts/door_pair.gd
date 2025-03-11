extends Node2D

@export var layerDoor1 := 0
@export var layerDoor2 := 3


@onready var Door1 := $Door1
@onready var Door2 := $Door2

var height := 206

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Door1.position.y = layerDoor1 * height
	Door2.position.y = layerDoor2 * height
	
	Door1.setTargetDoor(Door2)
	Door2.setTargetDoor(Door1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
