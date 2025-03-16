extends Node

@onready var guard = get_parent() as CharacterBody2D
@onready var sp = guard.get_node("AnimatedSprite2D")
@onready var raycast = guard.get_node("RayCast2D")

func update_animation(direction_x):
	if abs(direction_x) > 0.1:
		if sp.animation != "run":
			sp.play("run")
		var facing_left = direction_x < 0
		sp.flip_h = facing_left
		raycast.target_position.x = -abs(raycast.target_position.x) if facing_left else abs(raycast.target_position.x)
	else:
		if sp.animation != "idle":
			sp.play("idle")

func _on_animation_finished():
	if sp.animation == "attack":
		guard.get_node("GuardCombat").attacking = false
