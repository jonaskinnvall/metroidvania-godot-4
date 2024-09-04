extends Node2D

@export var acceleration: int = 200
@export var max_speed: int = 800

var state: Callable = _rush_state
var velocity: Vector2 = Vector2.ZERO
@onready var boss_stats: BaseStats = $BossStats


func _process(delta: float) -> void:
	state.call(delta)


func _rush_state(delta: float) -> void:
	var player : Player = MainInstances.player
	if not player is Player: return 

	var direction: Vector2 = global_position.direction_to(player.global_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	
	move(delta)


func move(delta: float) -> void:
	translate(velocity * delta)


func _fire_state(_delta: float) -> void:
	pass


func _on_hurtbox_hurt(_hitbox: Area2D, damage: int) -> void:
	boss_stats.health -= damage


func _on_boss_stats_no_health() -> void:
	queue_free()
