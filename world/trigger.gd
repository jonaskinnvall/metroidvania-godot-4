extends Area2D


signal _entered


func _on_body_entered(_body: Node2D) -> void:
	_entered.emit()
