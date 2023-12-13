class_name Hurtbox
extends Area2D

signal hurt(hitbox: Area2D, damage: int)


func take_hit(hitbox: Area2D, damage: int) -> void:
	hurt.emit(hitbox, damage)
