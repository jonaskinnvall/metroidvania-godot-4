extends ColorRect

@onready var start_button: Button = $CenterContainer/VBoxContainer/StartButton


func _ready() -> void:
	PlayerStats.reset()
	start_button.grab_focus.call_deferred()


func _process(_delta: float) -> void:
	var current_focus: Button = get_viewport().gui_get_focus_owner()
	if Input.is_action_just_pressed('ui_select'):
		current_focus.pressed.emit()


func _on_start_button_pressed() -> void:
	Sound.play(Sound.click, 1.0, -10.0)
	get_tree().change_scene_to_file('res://world.tscn')


func _on_load_button_pressed() -> void:
	Sound.play(Sound.click, 1.0, -10.0)
	SaveManager.is_loading = true
	get_tree().change_scene_to_file('res://world.tscn')


func _on_quit_button_pressed() -> void:
	Sound.play(Sound.click, 1.0, -10.0)
	get_tree().quit()
