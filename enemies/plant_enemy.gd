extends Node2D

const EnemyBulletScene: PackedScene = preload('res://enemies/enemy_bullet.tscn')
const EnemyDeathEffect: PackedScene = preload('res://effects/enemy_death_effect.tscn')

@export var bullet_speed: int = 30
@export var spread: int = 30
@onready var base_stats: BaseStats = $BaseStats
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var fire_direction: Marker2D = $FireDirection


func fire_bullet() -> void:
	var bullet: Projectile = Utils.instanstiate_to_world(EnemyBulletScene, bullet_spawn_point.global_position)
	var direction: Vector2 = global_position.direction_to(fire_direction.global_position) 
	bullet.velocity = (direction * bullet_speed).rotated(randf_range(-deg_to_rad(spread/2),deg_to_rad(spread/2)))


func _on_hurtbox_hurt(_hitbox: Area2D, damage: int) -> void:
	base_stats.health -= damage


func _on_base_stats_no_health() -> void:
	Utils.instanstiate_to_world(EnemyDeathEffect, bullet_spawn_point.global_position)
	queue_free()
