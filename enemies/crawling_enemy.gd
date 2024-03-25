extends Node2D

const EnemyDeathEffectScene: PackedScene = preload('res://effects/enemy_death_effect.tscn')

enum Direction {LEFT = -1, RIGHT = 1}

@export var crawling_direction: Direction = Direction.RIGHT
@export var max_speed: int = 250
@onready var wall_cast: RayCast2D = $WallCast
@onready var floor_cast: RayCast2D = $FloorCast
@onready var base_stats: BaseStats = $BaseStats


func _ready() -> void:
	wall_cast.target_position.x *= crawling_direction


func _physics_process(delta: float) -> void:
	if wall_cast.is_colliding():
		global_position = wall_cast.get_collision_point()
		var wall_normal: Vector2 = wall_cast.get_collision_normal()
		rotation = wall_normal.rotated(deg_to_rad(90)).angle()
	else: 
		floor_cast.rotation_degrees = -max_speed * crawling_direction * delta
		if floor_cast.is_colliding():
			global_position = floor_cast.get_collision_point()
			var floor_normal: Vector2 = floor_cast.get_collision_normal()
			rotation = floor_normal.rotated(deg_to_rad(90)).angle()
		else:
			rotation_degrees += crawling_direction


func _on_hurtbox_hurt(_hitbox: Area2D, damage: int) -> void:
	base_stats.health -= damage


func _on_base_stats_no_health() -> void:
	Utils.instanstiate_to_world(EnemyDeathEffectScene, global_position)
	queue_free()
