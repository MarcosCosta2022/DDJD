extends Node2D

@onready var sprite = $Sprite2D
@onready var area2d = $Area2D
@onready var interactable = $Interactable

@export var Game : Node2D

func _ready():
	interactable.interacted.connect(drink_coffee)  # Connect signal

func drink_coffee():
	# get player
	var player = Game.get_player()
	
	if (player.coins >0) :
		# activate speed boost
		player.use_coin()
		player.drink_coffee()
	else:
		player.get_thoughts().say("I need to get a coin to buy a coffe!")
		
	
