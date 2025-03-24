extends Control

@onready var score_label = $ScoreLabel
@onready var time_label = $TimeLabel
@onready var watched_icon = $WatchedIcon
@onready var game_over_screen = $GameOver
@onready var speed_boost_icon = $CoffeeIcon
@onready var game_win_screen = $"Win Screen"
@onready var invisible_icon = $InvisibilityIcon
@onready var coat_icon = $CoatIcon
@onready var lecture_notes_container = $LectureNotes # HBoxContainer
@onready var key_card_icon = $KeyCard
@onready var coin_icon = $CoinIcon
@onready var coin_amount_label = $CoinIcon/Amount
@onready var int_label = $CenterContainer/Interacti
@onready var exams_icon = $ExamsIcon

@onready var deactivated_camera_icon = $CameraIcon
@onready var deactivated_camera_progress_bar = $CameraIcon/TextureProgressBar

var game

var player_is_visible = false

func _ready():
	# get level parent
	game = get_parent()
	
	# Update score when the game starts
	print(get_tree_string())
	update_score(game.score)
	
	# Connect to Game's score change function (we'll modify Game next)
	game.score_changed.connect(update_score)
	
	update_lecture_notes_visibility(0)
	
func pre_process(delta: float)-> void:
	# call this in root node so its executed first
	int_label.visible = false
	
func _process(delta: float) -> void:
	# if the player is visible display the eye icon
	watched_icon.visible = player_is_visible
	
	# set the player is visible to false again
	player_is_visible = false

func update_score(new_score):
	pass
	
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
	
func show_game_over_screen():
	if(game_over_screen):
		game_over_screen.visible = true
		
func show_speed_boost():
	speed_boost_icon.visible = true
	print("Cooffe")
	
func hide_speed_boost():
	speed_boost_icon.visible = false
	
func show_game_win_screen(value):
	game_win_screen.change_score_container(value)
	game_win_screen.visible = true
	
func show_coat_icon():
	coat_icon.visible = true

func hide_coat_icon():
	coat_icon.visible = false

func show_invisible_icon():
	invisible_icon.visible = true

func update_invisible_icon(invisibility):
	invisible_icon.update_invisibility_display(invisibility)
	
func update_lecture_notes_visibility(found_count: int):
	for i in range(lecture_notes_container.get_child_count()):
		var child = lecture_notes_container.get_child(i)
		if child is CanvasItem:
			if i < found_count:
				child.modulate = Color(1, 1, 1, 1)  # No modulate (fully visible)
			else:
				child.modulate = Color(0.5, 0.5, 0.5, 1)  # Darker (locked)

func show_key_card_icon(show):
	key_card_icon.visible = show

func show_coin_icon(amount):
	coin_icon.visible = amount > 0
	coin_amount_label.visible = amount > 1
	coin_amount_label.text = "x" + str(amount)
	
func show_interaction(text):
	int_label.visible = true
	int_label.text = text
	
func show_exams_icon(show):
	exams_icon.visible = show
	
func update_camera_icon(progress):
	if progress <= 0:
		deactivated_camera_icon.visible = false 
		return 
	deactivated_camera_icon.visible = true
	deactivated_camera_progress_bar.value = progress
