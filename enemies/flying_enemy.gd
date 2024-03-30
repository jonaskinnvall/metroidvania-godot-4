extends CharacterBody2D

const EnemyDeathEffect: PackedScene = preload('res://effects/enemy_death_effect.tscn')

@export var speed: int = 100
@export var max_speed: int = 30
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var base_stats: BaseStats = $BaseStats


func _physics_process(delta: float) -> void:
	var player : CharacterBody2D = MainInstances.player
	
	if player is CharacterBody2D:
		var direction: Vector2 = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * max_speed, speed * delta)

		animated_sprite_2d.flip_h = global_position < player.global_position
		move_and_slide()


func _on_hurtbox_hurt(hitbox: Area2D, damage: int) -> void:
	base_stats.health -= damage


func _on_base_stats_no_health() -> void:
	Utils.instanstiate_to_world(EnemyDeathEffect, global_position)
	queue_free()
