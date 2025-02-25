extends Node2D

@export var float_speed := 2.0
@export var float_amplitude := 5.0

var start_y := 0.0
var time := 0.0
var player_inside = false

@onready var sprite = $Sprite2D
@onready var area2d = $Area2D

func _ready():
	start_y = sprite.position.y
	area2d.body_entered.connect(_on_Area2D_body_entered)
	area2d.body_exited.connect(_on_Area2D_body_exited)

func _process(delta):
	time += delta
	sprite.position.y = start_y + sin(time * float_speed) * float_amplitude
	if player_inside and Input.is_action_just_pressed("interact"):
		get_picked()
	
	
func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player_inside = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player_inside = false
		
func get_picked():
	Game.increase_score(10)  # Call function in the global Game script
	queue_free()  # Delete the note object after picking
