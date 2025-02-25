extends Control

@onready var score_label = $ScoreLabel

func _ready():
	# Update score when the game starts
	update_score(Game.score)
	
	# Connect to Game's score change function (we'll modify Game next)
	Game.score_changed.connect(update_score)

func update_score(new_score):
	score_label.text = "Score: " + str(new_score)
