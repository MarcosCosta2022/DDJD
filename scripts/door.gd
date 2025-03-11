extends Node2D

var target_door: Node2D

var playerNear := false
var player = null

func _ready() -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		playerNear = true
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body.name == "Player"):
		playerNear = false
		player = null
		
func _process(delta: float) -> void:
	if (playerNear and Input.is_action_just_pressed("ui_up")):
		teleport()
	
func teleport() -> void:
	if (player != null):
		player.position.x = target_door.global_position.x - 22
		player.position.y = target_door.global_position.y + 40 # -30 and +60 to center the character with the door
		print(player.position)
	

func setTargetDoor (targetDoor : Node2D) -> void:
	self.target_door = targetDoor
	
