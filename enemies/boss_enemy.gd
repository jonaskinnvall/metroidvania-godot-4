extends Node2D

const StingerScene: PackedScene = preload('res://enemies/stinger.tscn')

@export var acceleration: int = 200
@export var max_speed: int = 800

var state: Callable = _fire_state
var velocity: Vector2 = Vector2.ZERO
@onready var boss_stats: BaseStats = $BossStats
@onready var fire_timer: Timer = $FireTimer
@onready var stinger_pivot: Marker2D = $StingerPivot
@onready var muzzle: Marker2D = $StingerPivot/Muzzle


func _process(delta: float) -> void:
	state.call(delta)


func _rush_state(delta: float) -> void:
	var player : Player = MainInstances.player
	if not player is Player: return 

	var direction: Vector2 = global_position.direction_to(player.global_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	
	move(delta)


func _fire_state(_delta: float) -> void:
	if fire_timer.time_left == 0:
		stinger_pivot.rotation_degrees += 17
		fire_timer.start()
		var stinger: Node2D = Utils.instantiate_to_level(StingerScene, muzzle.global_position)
		stinger.rotation = stinger_pivot.rotation
		stinger.update_velocity_based_on_rotation()


func move(delta: float) -> void:
	translate(velocity * delta)


func _on_hurtbox_hurt(_hitbox: Area2D, damage: int) -> void:
	boss_stats.health -= damage


func _on_boss_stats_no_health() -> void:
	queue_free()
