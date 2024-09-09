extends ColorRect


func _on_load_button_pressed() -> void:
	Sound.play(Sound.click, 1.0, -10.0)
	SaveManager.is_loading = true
	get_tree().change_scene_to_file('res://world.tscn')


func _on_main_menu_button_pressed() -> void:
	Sound.play(Sound.click, 1.0, -10.0)
	WorldStash.data = {}
	get_tree().paused = false
	get_tree().change_scene_to_file('res://menus/start_menu.tscn')


func _on_quit_button_pressed() -> void:
	Sound.play(Sound.click, 1.0, -10.0)
	get_tree().quit()
