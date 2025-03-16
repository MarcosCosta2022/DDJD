extends Node2D

var target_door: Node2D

@onready var interactable = $Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interacted.connect(teleport)  # Connect signal
	
func teleport() -> void:
	var player = interactable.get_player()
	if (player):
		player.position.x = target_door.global_position.x
		player.position.y = target_door.global_position.y

func setTargetDoor (targetDoor : Node2D) -> void:
	self.target_door = targetDoor
