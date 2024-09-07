extends ColorRect


func _on_start_button_pressed() -> void:
	Sound.play('click', 1.0, -10.0)
	get_tree().change_scene_to_file('res://world.tscn')


func _on_load_button_pressed() -> void:
	Sound.play('click', 1.0, -10.0)
	print('Load saved game')
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	Sound.play('click', 1.0, -10.0)
	get_tree().quit()
