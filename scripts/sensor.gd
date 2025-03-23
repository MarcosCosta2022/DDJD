extends Node2D

@export var game: Node2D
@export var player : CharacterBody2D

@onready var sp = $Sprite2D
@onready var it = $Interactable

var is_unlocked = false
@export var door : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# get game
	if not game:
		game = get_tree().root.get_child(0)
		
	if door:
		door.unlocked = is_unlocked
	
	it.interacted.connect(open_door)
	
func open_door()->void:
	if player_has_key():
		is_unlocked = true 
		door.unlocked = true
		door.open_door()
		it.queue_free() # Remove the interactable
	elif game and game.get_player():
		game.get_player().get_thoughts().say("The door is locked.\nI need to find the key.")
		
func player_has_key():
	if game and game.get_player():
		return game.get_player().has_keycard
	return false
