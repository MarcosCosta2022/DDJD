extends Node2D

var activated = true

var player_inside = false

@onready var sprite = $Sprite2D
@onready var area2d = $Area2D

func _ready():
	area2d.body_entered.connect(_on_Area2D_body_entered)
	area2d.body_exited.connect(_on_Area2D_body_exited)

func _process(delta):
	if player_inside and Input.is_action_just_pressed("interact") and activated:
		drink_coffe()
	
	
func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player_inside = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player_inside = false
		
func drink_coffe():
	Game.drink_coffe()
	activated = false
	
