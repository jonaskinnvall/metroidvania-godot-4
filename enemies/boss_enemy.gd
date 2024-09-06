extends Node2D

const StingerScene: PackedScene = preload('res://enemies/stinger.tscn')
const MissilePowerupScene: PackedScene = preload('res://player/missile_powerup.tscn')
const EnemyDeathEffectScene: PackedScene = preload('res://effects/enemy_death_effect.tscn')

@export var acceleration: int = 200
@export var max_speed: int = 800
@export var targets: Array[NodePath]
var STATES: Array[Callable] = [_rush_state, _fire_state, _rush_state, _fire_state]
var states_left: Array = []
var state: Callable = _recenter_state : set = _set_state
var state_init: bool = true : get = _get_state_init
var velocity: Vector2 = Vector2.ZERO
@onready var boss_stats: BaseStats = $BossStats
@onready var stinger_pivot: Marker2D = $StingerPivot
@onready var muzzle: Marker2D = $StingerPivot/Muzzle
@onready var fire_timer: Timer = $FireTimer
@onready var state_timer: Timer = $StateTimer


func _ready() -> void:
	if WorldStash.retrieve('first_boss', 'freed'):
		queue_free()


func _process(delta: float) -> void:
	state.call(delta)


func _set_state(value: Callable) -> void:
	state = value
	state_init = true


func _get_state_init() -> bool:
	var was: bool = state_init
	state_init = false
	return was


func _start_next_state_timer(next_state: Callable) -> void:
	if state_init:
		state_timer.start(randf_range(2.0,6.0))
		state_timer.timeout.connect(_set_state.bind(next_state),CONNECT_ONE_SHOT)


func _rush_state(delta: float) -> void:
	_start_next_state_timer(_decelerate_state)
	
	var player : Player = MainInstances.player
	if not player is Player: return 

	var direction: Vector2 = global_position.direction_to(player.global_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	_move(delta)


func _fire_state(_delta: float) -> void:
	_start_next_state_timer(_recenter_state)
		
	if fire_timer.time_left == 0:
		stinger_pivot.rotation_degrees += 17
		fire_timer.start()
		var stinger: Node2D = Utils.instantiate_to_level(StingerScene, muzzle.global_position)
		stinger.rotation = stinger_pivot.rotation
		stinger.update_velocity_based_on_rotation()


func _recenter_state(_delta: float) -> void:
	assert(not targets.is_empty())
	if state_init:
		var target_node: Node2D = get_node(targets.pick_random())
		var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "global_position", target_node.global_position, 2.0)
		await  tween.finished
		state_timer.start(0.5)
		await state_timer.timeout
		if states_left.is_empty():
			states_left = STATES.duplicate()
			states_left.shuffle()
		state = states_left.pop_back()


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
	WorldStash.stash('first_boss', 'freed', true)
	Utils.instantiate_to_level(MissilePowerupScene, global_position)
	for i: int in 6:
		Utils.instantiate_to_level(EnemyDeathEffectScene, global_position + Vector2(randf_range(-16,16), randf_range(-16,16)))
