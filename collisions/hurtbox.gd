class_name Hurtbox
extends Area2D

signal hurt(hitbox, damage)


func take_hit(hitbox: Area2D, damage: int) -> void:
	hurt.emit(hitbox, damage)
