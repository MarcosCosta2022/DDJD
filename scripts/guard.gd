extends Node2D

@onready var path = $Path2D/PathFollow2D
@onready var sprite = $Path2D/PathFollow2D/CharacterBody2D/Sprite2D
@onready var cb = $Path2D/PathFollow2D/CharacterBody2D

@onready 

@export var speed = 100
@export var wait_time = 2  # Time to wait at the ends

var direction = 1  # 1 means moving forward, -1 means moving backward
var waiting = false
	

func _process(delta: float) -> void:
	if waiting:
		return
	
	var previous_progress = path.progress_ratio
	path.progress += direction * speed * delta
	
	if (direction == 1  and path.progress_ratio < previous_progress) or (direction == -1 and path.progress_ratio > previous_progress):
		path.progress_ratio = direction == 1
		direction *= -1  # Reverse direction
		waiting = true
		await get_tree().create_timer(wait_time).timeout
		waiting = false
		# flip the sprite
		sprite.flip_h = (direction == 1)
