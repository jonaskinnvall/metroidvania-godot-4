class_name Trigger
extends Area2D


var is_active: bool = true
signal _entered


func _on_body_entered(_body: Node2D) -> void:
	if is_active:
		_entered.emit()
