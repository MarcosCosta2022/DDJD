extends Node2D

@onready var it = $Interactable
@export var game : Node2D
@onready var sp = $Sprite2D
@onready var floating_ui = $FloatingUI # Reference to the control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not game:
		game = get_tree().root.get_child(0)
	
	it.interacted.connect(pick_hidden_note)
	floating_ui.visible = false  # Ensure it starts hidden

func pick_hidden_note() -> void:
	if game:
		game.pick_note()
	# get rid of the interactable so the user cant interact any more
	it.queue_free()
	show_floating_ui()
	await get_tree().create_timer(1.0).timeout  # Wait 1 second before deleting
	queue_free()

func show_floating_ui() -> void:
	floating_ui.scale = Vector2.ONE *4 # Reset scale to ensure consistency
	floating_ui.global_position = global_position  # Place UI at the note's position
	floating_ui.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(floating_ui, "position:y", floating_ui.position.y - 50, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(floating_ui, "modulate:a", 0.0, 0.5).set_delay(0.5)
	tween.tween_callback(delete_floating_ui)

func delete_floating_ui() -> void:
	floating_ui.queue_free()
