extends Node2D

@export var game : Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and body.has_exams:
		game.game_win()
