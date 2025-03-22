extends Sprite2D

@onready var it = $Interactable

@export var float_speed := 2.0
@export var float_amplitude := 5.0
var start_y := 0.0
var time := 0.0

@export var game: Node2D = null  # Allow setting from Inspector, default to null

func _ready():
	start_y = position.y  # Use 'position' instead of 'sprite.position'
	it.interacted.connect(pick_coin)
	if game == null:
		game = get_tree().root.get_child(0) as Node2D

func pick_coin():
	var player = game.get_player()
	
	player.add_coin()
	
	queue_free()

func _process(delta):
	time += delta
	position.y = start_y + sin(time * float_speed) * float_amplitude  # Apply wobbling to self
		
func get_picked():
	game.pick_note()
	queue_free()  # Delete the note object after picking
