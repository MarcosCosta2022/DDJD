extends Control

@onready var score_label = $ScoreLabel
@onready var time_label = $TimeLabel
@onready var watched_icon = $WatchedIcon

var game

var player_is_visible = false

func _ready():
	# get level parent
	game = get_parent()
	
	# Update score when the game starts
	update_score(game.score)
	
	# Connect to Game's score change function (we'll modify Game next)
	game.score_changed.connect(update_score)
	
func _process(delta: float) -> void:
	# if the player is visible display the eye icon
	watched_icon.visible = player_is_visible
	
	# set the player is visible to false again
	player_is_visible = false

func update_score(new_score):
	score_label.text = "Score: " + str(new_score)
	
func update_time(time):
	# Convert seconds to "MM:SS" format
	var minutes = int(time / 60.0)  # Integer division for minutes
	var seconds = int(time) % 60  # Convert float to int before applying modulus for seconds

	# Format as "MM:SS" and update the time label
	time_label.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	
func update_eye_sprite(active):
	watched_icon.visible = active

func seeing_player():
	player_is_visible = true
