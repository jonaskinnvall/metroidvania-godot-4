class_name Projectile
extends Node2D

const ExplosionEffectScene: PackedScene = preload('res://effects/explosion_effect.tscn')

@export var  speed: int = 250
var velocity: Vector2 = Vector2.ZERO
var screen_entered: bool = false


func _ready() -> void:
	Sound.play(Sound.bullet, randf_range(0.6, 1.2))


func _process(delta: float) -> void:
	position += velocity * delta


func update_velocity_based_on_rotation() -> void:
	velocity.x = speed
	velocity = velocity.rotated(rotation)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_hitbox_area_entered(_area: Area2D) -> void:
	Utils.instantiate_to_level(ExplosionEffectScene, global_position)
	queue_free()


func _on_hitbox_body_entered(_body: Node2D) -> void:
	Utils.instantiate_to_level(ExplosionEffectScene, global_position)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	screen_entered = true


func _on_timer_timeout() -> void:
	if screen_entered: return
	queue_free()
