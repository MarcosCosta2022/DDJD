extends Node

@onready var player = $Player

var score: int = 0

# Define a signal to notify when the score changes
signal score_changed(new_score)

func _ready() -> void:
	print("Player object")
	print(player)

func increase_score(amount: int):
	score += amount
	score_changed.emit(score)  # Emit the new score
	
func drink_coffe():
	print("Increased speed")
	
