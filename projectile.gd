class_name Projectile
extends Node2D

const ExplosionEffectScene: PackedScene = preload('res://effects/explosion_effect.tscn')

@export var  speed: int = 250
var velocity: Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	position += velocity * delta


func update_velocity_based_on_rotation() -> void:
	velocity.x = speed
	velocity = velocity.rotated(rotation)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_hitbox_area_entered(_area: Area2D) -> void:
	Utils.instanstiate_to_world(ExplosionEffectScene, global_position)
	queue_free()


func _on_hitbox_body_entered(_body: Node2D) -> void:
	Utils.instanstiate_to_world(ExplosionEffectScene, global_position)
	queue_free()
