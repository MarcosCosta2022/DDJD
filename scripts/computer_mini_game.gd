extends Node2D

@onready var minigame = $Game
@onready var startPage = $StartPage

@onready var locked_component = $StartPage/BlockedInterface
@onready var progress_bar = $StartPage/TextureProgressBar

@onready var unlocked_label = $StartPage/Label2 

var locked = false
var won = false

@export var blocking_time = 15 # 15 secoonds
@export var hacking_time = 20 # 20 segundos

@onready var timer = $Timer
var timer_duration = 0

var phase = "start"

var open = false

@export var game : Node2D

func _ready()-> void:
	update_game_phase()
	game = get_parent()

func update_game_phase():
	if phase == "start":
		startPage.visible = true
		minigame.visible = false
		minigame.running = false
		locked_component.visible = locked 
		unlocked_label.visible = not locked
		progress_bar.visible = locked
	elif phase == "game":
		startPage.visible = false
		minigame.visible = true
		minigame.running = true
		
		
func start_game():
	
	phase = "game"
	update_game_phase()
	minigame.start()
		 
func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_W) and open and phase == "start" and not locked:
		start_game()
	if Input.is_key_pressed(KEY_ESCAPE) and open:
		game.close_mini_hacking_game()
	
	# Update progress bar when locked
	if locked:
		update_progress_bar()
		
func update_progress_bar():
	if locked:
		var time_left = timer.time_left
		progress_bar.value = (time_left / timer_duration) * 100
	
func initialize_progress_bar(duration, color):
	timer_duration = duration
	progress_bar.value = 0  # Reset progress bar
	progress_bar.tint_progress = color
	timer.wait_time = duration
	timer.start()
	locked_component.visible = true  # Show the locked screen

func _on_timer_timeout():
	timer.stop()
	if (won == true) and game:
		game.toggle_security()
	locked = false
	locked_component.visible = false  # Hide the locked screen
	progress_bar.visible = false
	progress_bar.value = 100
	unlocked_label.visible = true  # Show a message if needed
	
	print("Unlocked!")

func _on_game_won() -> void:
	phase = "start"
	won = true
	locked = true
	initialize_progress_bar(hacking_time, Color(0,1,0))
	update_game_phase()
	if game:
		game.toggle_security()
		game.close_mini_hacking_game()
	print("Deactivated cameras")


func _on_game_lost() -> void:
	phase = "start"
	locked = true
	won = false
	
	initialize_progress_bar(blocking_time, Color(1,0,0))
	
	update_game_phase()
	print("Blocked")
