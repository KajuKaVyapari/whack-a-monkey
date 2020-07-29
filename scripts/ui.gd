extends Control


var paused = false

func _on_exit_button_pressed():
	get_tree().quit()


func _on_pause_button_pressed():
	if not paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$buttons/pause_button.texture_normal = load("res://assets/ui/play_button.png")
		paused = true
		get_tree().paused = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		$buttons/pause_button.texture_normal = load("res://assets/ui/pause_button.png")
		paused = false
		get_tree().paused = false


func _on_menu_button_pressed():
	paused = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://scenes/main_menu.tscn")


func _on_play_button_pressed():
	paused = false
	get_tree().paused = false
	get_tree().change_scene("res://scenes/world.tscn")


func _ready():
	if not $play_button == null:
		$play_button.texture_normal = load("res://assets/ui/play_button.png")
	if not $score == null:
		$score.text = "Score: " + str(global.score)
		$highscore.text = "Highscore: " + str(global.highscore)
		global.score = -1
