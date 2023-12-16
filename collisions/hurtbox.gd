class_name Hurtbox
extends Area2D

signal hurt(hitbox: Area2D, damage: int)

var is_invincible: bool = false :
	set(value):
		is_invincible = value
		disable.call_deferred(value)

func take_hit(hitbox: Area2D, damage: int) -> void:
	if is_invincible: return
	hurt.emit(hitbox, damage)


func disable(value: bool) -> void:
	for child: Node in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.disabled = value
