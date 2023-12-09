class_name Projectile
extends Node2D

@export var  speed: int = 250

var velocity: Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	position += velocity * delta


func update_rotation() -> void:
	velocity.x = speed
	velocity = velocity.rotated(rotation)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
