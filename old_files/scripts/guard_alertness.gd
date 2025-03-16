extends Node

var alert_increase_rate: float
var alert_decrease_rate: float
var max_alertness: float
var alertness: float = 0.0

func initialize(new_increase: float, new_decrease: float, new_max: float):
	alert_increase_rate = new_increase
	alert_decrease_rate = new_decrease
	max_alertness = new_max

func is_player_visible() -> bool:
	# Vision logic here
	return false

func update_alertness_display():
	# Alertness display logic here
	pass
