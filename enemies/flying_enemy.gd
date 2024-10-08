extends CharacterBody2D

const EnemyDeathEffect: PackedScene = preload('res://effects/enemy_death_effect.tscn')

@export var speed: int = 100
@export var max_speed: int = 30
var has_seen_player: bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var base_stats: BaseStats = $BaseStats
@onready var waypoint_pathfinding: Node2D = $WaypointPathfinding


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	var player : Player = MainInstances.player
	
	if not has_seen_player and player is Player:
		has_seen_player = waypoint_pathfinding.can_see_target(global_position)
		return

	if player is Player:
		var direction: Vector2 = global_position.direction_to(waypoint_pathfinding.pathfinding_next_position)
		velocity = velocity.move_toward(direction * max_speed, speed * delta)

		animated_sprite_2d.flip_h = global_position < player.global_position
		move_and_slide()


func _on_hurtbox_hurt(_hitbox: Area2D, damage: int) -> void:
	base_stats.health -= damage


func _on_base_stats_no_health() -> void:
	Utils.instantiate_to_level(EnemyDeathEffect, global_position)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	set_physics_process(true)
