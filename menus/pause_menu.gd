extends ColorRect

var paused: bool = false:
	set(value):
		paused = value
		get_tree().paused = paused
		visible = paused
		if paused:
			Sound.play(Sound.pause, 1.0, -10.0)
			resume_button.grab_focus.call_deferred()
		else:
			Sound.play(Sound.unpause, 1.0, -10.0)

@onready var resume_button: Button = $CenterContainer/VBoxContainer/ResumeButton


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('pause') and MainInstances.player is Player:
		paused = !paused
		
	if paused:
		var current_focus: Button = get_viewport().gui_get_focus_owner()
		if Input.is_action_just_pressed('ui_select'):
			current_focus.pressed.emit()

func _on_resume_button_pressed() -> void:
	Sound.play(Sound.click, 1.0, -10.0)
	paused = false


func _on_main_menu_button_pressed() -> void:
	Sound.play(Sound.click, 1.0, -10.0)
	WorldStash.data = {}
	get_tree().paused = false
	get_tree().change_scene_to_file('res://menus/start_menu.tscn')


func _on_quit_button_pressed() -> void:
	Sound.play(Sound.click, 1.0, -10.0)
	get_tree().quit()
