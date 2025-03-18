extends Sprite2D

@export var id = 0
@onready var it = $Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	it.interacted.connect(pick_up_card)

func pick_up_card()->void:
	# get player
	var player = it.get_player()
	# add key card to players inventory
	player.add_keycard()
	# remove itseelf from the map
	remove_self()
	
func remove_self():
	queue_free()
