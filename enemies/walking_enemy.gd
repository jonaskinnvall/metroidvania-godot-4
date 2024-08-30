extends CharacterBody2D

const EnemyDeathEffect: PackedScene = preload('res://effects/enemy_death_effect.tscn')

@export var speed: float = 30.0
@export var turns_on_ledge: bool = true
var direction: float = 1.0
var gravity: float = 200.0
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var stats: Node = $Stats
@onready var death_effect_spawn_location: Marker2D = $DeathEffectSpawnLocation


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_wall() or (is_on_ledge() and turns_on_ledge):
		turn_around()
	
	velocity.x =  direction * speed
	sprite_2d.scale.x = direction

	move_and_slide()


func turn_around() -> void:
	direction *= -1.0


func is_on_ledge() -> bool:
	return is_on_floor() and not ray_cast_2d.is_colliding()


func _on_hurtbox_hurt(_hitbox: Variant, damage: Variant) -> void:
	stats.health -= damage


func _on_stats_no_health() -> void:
	Utils.instantiate_to_level(EnemyDeathEffect, death_effect_spawn_location.global_position)
	queue_free()
