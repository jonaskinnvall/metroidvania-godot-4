extends ColorRect

var paused: bool = false:
	set(value):
		paused = value
		get_tree().paused = paused
		visible = paused
		if paused:
			Sound.play('pause', 1.0, -10.0)
		else:
			Sound.play('unpause', 1.0, -10.0)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('pause'):
		paused = !paused


func _on_resume_button_pressed() -> void:
	Sound.play('click', 1.0, -10.0)
	paused = false


func _on_quit_button_pressed() -> void:
	Sound.play('click', 1.0, -10.0)
	get_tree().quit()
