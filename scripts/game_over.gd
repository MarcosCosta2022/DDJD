extends Control

# Called when the user clicks on the restart button
func _on_restart_button_pressed():
	# Called when the user clicks on the restart button and it loads the current scene again
	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()  # Reloads the current scene

func change_score_container(score):
	var scoreLabel := $ScoreContainer/Label
	scoreLabel.set_text("Final Score: " + str(score))
