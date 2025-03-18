extends Node2D

@export var float_speed := 2.0
@export var float_amplitude := 5.0

var start_y := 0.0
var time := 0.0
var player_inside = false
var player = null

@onready var sprite = $Sprite2D
@onready var area2d = $Area2D

@export var game: Node2D = null  # Allow setting from Inspector, default to null

func _ready():
	start_y = sprite.position.y
	area2d.body_entered.connect(_on_Area2D_body_entered)
	area2d.body_exited.connect(_on_Area2D_body_exited)
	if game == null:
		game = get_tree().root.get_child(0) as Node2D
		player = get_parent().get_node("Player")

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
	player.pick_coat()
	queue_free()
	
