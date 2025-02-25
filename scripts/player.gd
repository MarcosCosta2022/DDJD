extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var gravity = 10

@onready var ap = $AnimationPlayer
@onready var sp = $Sprite2D

var points = 0;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += Vector2(0,gravity) * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		switch_direction(direction);
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	update_animations(direction)
	
	
func update_animations(horizontal_direction):
	if is_on_floor():
		if horizontal_direction ==0:
			ap.play("idle")
		else:
			ap.play("run")
	else:
		if velocity.y < 0:
			ap.play("jump")
		elif velocity.y > 0:
			ap.play("fall")
		
func switch_direction(horizontal_direction):
	sp.flip_h = (horizontal_direction == -1)
	if (horizontal_direction == 1):
		sp.position.x = 4
	elif (horizontal_direction == -1):
		sp.position.x = -6
	
	
