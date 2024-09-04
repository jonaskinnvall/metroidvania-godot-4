extends Node2D

const StingerScene: PackedScene = preload('res://enemies/stinger.tscn')

@export var acceleration: int = 200
@export var max_speed: int = 800
@export var targets: Array[NodePath]
var state: Callable = _rush_state
var velocity: Vector2 = Vector2.ZERO
@onready var boss_stats: BaseStats = $BossStats
@onready var stinger_pivot: Marker2D = $StingerPivot
@onready var muzzle: Marker2D = $StingerPivot/Muzzle
@onready var fire_timer: Timer = $FireTimer
@onready var state_timer: Timer = $StateTimer


func _process(delta: float) -> void:
	state.call(delta)


func _rush_state(delta: float) -> void:
	var player : Player = MainInstances.player
	if not player is Player: return 

	var direction: Vector2 = global_position.direction_to(player.global_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	_move(delta)


func _fire_state(_delta: float) -> void:
	if fire_timer.time_left == 0:
		stinger_pivot.rotation_degrees += 17
		fire_timer.start()
		var stinger: Node2D = Utils.instantiate_to_level(StingerScene, muzzle.global_position)
		stinger.rotation = stinger_pivot.rotation
		stinger.update_velocity_based_on_rotation()


func _recenter_state(_delta: float) -> void:
	assert(not targets.is_empty())
	set_process(false)
	var target_node: Node2D = get_node(targets.pick_random())
	
	var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", target_node.global_position, 2.0)
	await  tween.finished
	set_process(true)
	state = _rush_state


func _decelerate_state(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
	_move(delta)
	if velocity == Vector2.ZERO:
		state = _recenter_state


func _move(delta: float) -> void:
	translate(velocity * delta)


func _on_hurtbox_hurt(_hitbox: Area2D, damage: int) -> void:
	boss_stats.health -= damage


func _on_boss_stats_no_health() -> void:
	queue_free()


func _on_state_timer_timeout() -> void:
	state = _decelerate_state
