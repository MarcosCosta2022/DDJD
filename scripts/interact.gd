extends Area2D

signal interacted  # Define a signal

var player_inside = false
var player = null

@export var interaction_type = "interact"
@export var show_interaction = true
@export var text_shown = "Press 'E' to interact"

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_inside = true
		player = body
		
func _on_body_exited(body):
	if body.name == "Player":
		player_inside = false
		player = null

func _process(delta: float) -> void:
	if player_inside and show_interaction:
		var game = get_tree().root.get_child(0)
		if game :
			var hud = game.get_node("HUD")
			hud.show_interaction(text_shown)
	
	if player_inside and Input.is_action_just_pressed(interaction_type):
		interacted.emit()  # Emit the signal

func get_player() :
	return player
