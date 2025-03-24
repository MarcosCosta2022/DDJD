extends Node2D

@onready var sprite = $Sprite2D
@onready var area2d = $Area2D
@onready var interactable = $Interactable

@export var Game : Node2D

func _ready():
	if (Game == null):
		Game = get_parent()
	interactable.interacted.connect(catch_note)  # Connect signal

func catch_note():
	# get player
	var player = Game.get_player()
	
	if not has_node("HiddenNote") :
		player.get_thoughts().say("There is nothing here.")
