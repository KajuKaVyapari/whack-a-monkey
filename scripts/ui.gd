extends Control


var paused = false

func _on_exit_button_pressed():
	get_tree().quit()


func _on_pause_button_pressed():
	if not paused:
		$buttons/pause_button.texture_normal = load("res://assets/ui/play_button.png")
		paused = true
		get_tree().paused = true
	else:
		$buttons/pause_button.texture_normal = load("res://assets/ui/pause_button.png")
		paused = false
		get_tree().paused = false
