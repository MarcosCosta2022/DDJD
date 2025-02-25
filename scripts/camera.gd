extends Node2D

@onready var sightArea = $Area2D
@onready var timer = $Timer 

func _ready() -> void:
	sightArea.body_entered.connect(_on_sight_area_body_entered)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()  # Start the timer

func _on_sight_area_body_entered(body):
	if body.name == "Player":
		print("Player detected")

func _on_timer_timeout():
	scale.x *= -1  # Flip horizontally
	timer.start()  # Restart the timer
