extends StaticBody2D


func _on_area_2d_body_entered(_body: Node2D) -> void:
	print('save')
	SaveManager.save_to_file()
