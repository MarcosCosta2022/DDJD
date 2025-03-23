extends Node2D

@export var player: Node2D  # Assign the player in the Inspector
@export var fov_angle: float = 90.0  # Field of view in degrees
@export var max_distance: float = 1000.0  # Maximum vision distance
@export var segments: int = 20  # Number of segments for smoothness

@onready var lens_marker = $Marker2D
@onready var ray = $RayCast2D  # Make sure the RayCast2D exists in the scene
@onready var direction_marker = $Direction  # Defines the forward vector
@onready var cameraOnSprite = $CameraOnSprite
@onready var cameraOffSprite = $CameraOffSprite
@onready var cameraAlertSprite = $CameraAlertSprite
@onready var alertnessIcon = $AlertnessIcon
@onready var sparks = $SparksParticles

@export var debug = false

var redraw = false
var active = true
var alert = false # is looking at the player

@export var hud : Control	

# Alertness mechanics
var alertness: float = 0.0  # Ranges from 0 to 100
var alertness_rate: float = 100.0 / 0.9  # 100 over 0.9z seconds (adjust as needed)
var alertness_decrease_rate: float = 100.0 / 3.0  # 100 over 3 seconds (adjust as needed)
var last_seen_time: float = -1.0  # Time when the player was last seen
var time_since_lost_sight: float = 0.0  # Tracks how long the player has been out of sight

var game : Node2D

func _ready() -> void:
	game = get_parent()
	
	if game and not hud:
		hud = game.get_node("HUD")
		
	set_camera_state(active)
		
	# subscribe to change_camera_state 
	game.change_camera_state.connect(set_camera_state)

func set_camera_state(is_active):
	self.active = is_active
	if not active:
		sparks.emitting = true  # Emit sparks when turning off
	else:
		sparks.emitting = false  # Stop emitting when turned on

func _process(delta):
	if active and not player.invisibility_activated and is_player_visible():
		react(delta)
		last_seen_time = Time.get_ticks_msec() / 1000.0  # Store the last seen time in seconds
		time_since_lost_sight = 0.0  # Reset lost sight timer
	else:
		alert = false
		if last_seen_time > 0:
			var current_time = Time.get_ticks_msec() / 1000.0
			time_since_lost_sight = current_time - last_seen_time
			if time_since_lost_sight >= 3.0:  # Wait 3 seconds before decreasing alertness
				alertness = max(alertness - alertness_decrease_rate * delta, 0)

	# update the alterness icon
	alertnessIcon.update_alertness_display(alertness)

	# Trigger game over if alertness reaches 100
	if alertness >= 100:
		game.game_over()
	
	if(redraw or debug):
		queue_redraw()
	
	update_visible_sprite()

func react(delta) -> void:
	alert = true
	alertness = min(alertness + alertness_rate * delta, 100)  # Increase alertness while in sight
	
	if hud:
		hud.seeing_player()
		

func _draw():
	if(debug):
		_draw_debug()

func _draw_debug():
	var lens_pos = to_local(lens_marker.global_position)  # Convert to local space
	var forward = (direction_marker.global_position - lens_marker.global_position).normalized()

	# Flip direction if scale.x is negative
	if scale.x < 0:
		forward.x *= -1  # Flip only X, keep Y the same

	# Compensate for scale in max_distance
	var adjusted_max_distance = max_distance / abs(scale.x)  # Adjust based on the node's scale

	# Define the two edges of the vision cone
	var angle_offset = deg_to_rad(fov_angle / 2)
	var left_edge = lens_pos + forward.rotated(-angle_offset) * adjusted_max_distance
	var right_edge = lens_pos + forward.rotated(angle_offset) * adjusted_max_distance

	# Generate points for the FOV arc
	var points = [lens_pos]  # Start at lens position
	for i in range(segments + 1):  # Create smooth arc
		var angle = -angle_offset + (i / float(segments)) * (angle_offset * 2)
		var arc_point = lens_pos + forward.rotated(angle) * adjusted_max_distance
		points.append(arc_point)

	# Draw the detection cone
	draw_colored_polygon(points, Color(1, 0, 0, 0.3))  # Semi-transparent red

	# Draw outline
	draw_line(lens_pos, left_edge, Color.RED, 2)
	draw_line(lens_pos, right_edge, Color.RED, 2)
	
	# Draw the player at its center position
	var player_center = to_local(player.get_center())
	draw_circle(player_center, 30, Color(0, 1, 0))  # Draw a green circle at the player position



func is_player_visible() -> bool:
	var lens_pos = lens_marker.global_position
	var player_pos = player.get_center()

	# Distance check
	var distance = lens_pos.distance_to(player_pos)
	if distance > max_distance:
		if debug: print("player too far")
		return false  # Player is too far
	
	# Adjust forward direction based on scale.x
	var forward = (direction_marker.position - lens_marker.position).normalized()
	if scale.x < 0:
		forward.x *= -1  # Flip only the X component, keep Y the same

	var to_player = (player_pos - lens_pos).normalized()
	var angle_to_player = rad_to_deg(forward.angle_to(to_player))

	# Correct angle range check
	if angle_to_player < -fov_angle / 2 or angle_to_player > fov_angle / 2:
		if debug: print("Player outside FOV")
		return false  # Player is outside FOV
	
	# Raycast check for obstacles
	ray.target_position = to_local(player.get_center())
	ray.force_raycast_update()

	var collider = ray.get_collider()
	if collider and collider != player:  # Ignore the player
		if debug: print("Player behind obstacle")
		return false  # Something else is blocking the view

	return true  # Player is visible!
	
func activate():
	active = true
	update_visible_sprite()
	
func update_visible_sprite():
	cameraOnSprite.visible = active and alertness == 0
	cameraOffSprite.visible = not active
	cameraAlertSprite.visible = active and alertness > 0
	
