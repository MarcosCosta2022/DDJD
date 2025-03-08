extends Node2D

var activated = true

@onready var sprite = $Sprite2D
@onready var area2d = $Area2D
@onready var interactable = $Interactable

@export var Game : Node2D

func _ready():
	interactable.interacted.connect(drink_coffee)  # Connect signal
		
func drink_coffee():
	# get player
	var player = Game.get_player()
	
	# activate speed boost
	player.drink_coffee()
	
	# deactivate the vendind machine so it cant be used anymore
	activated = false
	
