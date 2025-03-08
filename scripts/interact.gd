extends Area2D

signal interacted  # Define a signal

var player_inside = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_inside = true
		
func _on_body_exited(body):
	if body.name == "Player":
		player_inside = false

func _process(delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("interact"):
		interacted.emit()  # Emit the signal
