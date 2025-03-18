extends Node2D

@onready var open_sprite = $OpenDoorSprite
@onready var closed_sprite = $ClosedDoorSprite
@onready var interactable = $Interactable
@onready var barrier = $StaticBody2D

@export var open = false
@export var unlocked = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_visible_sprite()
	interactable.interacted.connect(tooggle_open)
	
func tooggle_open():
	if not unlocked: return # cant open it
	
	if open : close_door()
	else : open_door()

func open_door():
	open = true
	# Disable collision with layer 1
	barrier.set_collision_layer_value(1, false)
	#update visible sprite
	update_visible_sprite()
	
func close_door():
	open = false
	# Enable collision with layer 1
	barrier.set_collision_layer_value(1, true)
	update_visible_sprite()
	
func update_visible_sprite():
	open_sprite.visible = open 
	closed_sprite.visible = not open
