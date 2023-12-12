class_name Hitbox
extends Area2D

@export var damage: int = 1



func _on_area_entered(hurtbox: Hurtbox) -> void:
	hurtbox.take_hit(self, damage)
