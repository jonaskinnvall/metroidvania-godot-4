extends CharacterBody2D

const DustEffectScene: PackedScene = preload('res://effects/dust_effect.tscn')
const JumpEffectScene: PackedScene = preload('res://effects/jump_effect.tscn')
const WallJumpEffectScene: PackedScene = preload('res://effects/wall_jump_effect.tscn')

@export var acceleration: int = 512
@export var max_velocity: int = 64
@export var max_fall_velocity: int = 128
@export var gravity: int = 200
@export var friction: int = 256
@export var air_friction: int = 64
@export var jump_force: float = 128.0
@export var wall_velocity: int = 48
@export var max_wall_velocity: int = 128
var double_jump: bool = false
var state: Callable = move_state
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var player_blaster: Node2D = $PlayerBlaster
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var drop_timer: Timer = $DropTimer
@onready var camera_2d: Camera2D = $Camera2D
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer


func _ready() -> void:
	PlayerStats.no_health.connect(die)


func _physics_process(delta: float) -> void:
	state.call(delta)
	
	if Input.is_action_pressed('fire') and fire_rate_timer.time_left == 0:
		fire_rate_timer.start()
		player_blaster.fire_bullet()


func move_state(delta: float) -> void:
	apply_gravity(delta)
	
	var direction: float = Input.get_axis("move_left","move_right")
	if direction:
		apply_acceleration(direction, delta)
	else: 
		apply_friction(delta)
		
	jump_check()
	
	if Input.is_action_just_pressed('crouch'):
		set_collision_mask_value(2, false)
		drop_timer.start()

	update_animations(direction)
	
	var was_on_floor: bool = is_on_floor()
	move_and_slide()
	var just_left_edge: bool = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_edge:
		coyote_timer.start()
	
	wall_check()


func wall_state(delta: float) -> void:
	var wall_normal: Vector2 = get_wall_normal()
	sprite_2d.scale.x = sign(wall_normal.x)
	animation_player.play('wall_slide')
	velocity.y = clampf(velocity.y, -wall_velocity, max_wall_velocity)
	
	wall_jump_check(wall_normal.x)
	apply_wall_slide_gravity(delta)
	wall_detatch(delta, wall_normal.x)
	
	move_and_slide()


func wall_check() -> void:
	if not is_on_floor() and is_on_wall():
		state = wall_state
		double_jump = true
		create_dust_effect()

func wall_detatch(delta: float, wall_axis: float) -> void:
	if not is_on_wall() or is_on_floor():
		state = move_state
		
	if wall_axis < 0 and Input.is_action_just_pressed('move_left'):
		velocity.x = -acceleration * delta
		state = move_state
	if wall_axis > 0 and Input.is_action_just_pressed('move_right'):
		velocity.x = acceleration * delta
		state = move_state


func apply_wall_slide_gravity(delta: float) -> void:
	var slide_speed: int = wall_velocity
	if Input.is_action_pressed('crouch'):
		slide_speed = max_wall_velocity
	
	velocity.y = move_toward(velocity.y, slide_speed, delta * gravity)


func wall_jump_check(wall_axis: float) -> void:
	if Input.is_action_just_pressed("jump"):
		state = move_state
		velocity.x = wall_axis * max_velocity
		jump(jump_force * 0.75, false)
		var effect_position: Vector2 = global_position + Vector2(wall_axis * 4, -2)
		var wall_jump_effect:Node2D = Utils.instanstiate_to_world(WallJumpEffectScene, effect_position)
		wall_jump_effect.scale.x = wall_axis


func create_dust_effect() -> void:
	Utils.instanstiate_to_world(DustEffectScene, global_position)


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_velocity, gravity * delta)


func apply_acceleration(direction: float,delta: float) -> void:
	velocity.x = move_toward(velocity.x, direction * max_velocity, acceleration * delta)


func apply_friction(delta: float) -> void:
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, air_friction * delta)


func jump_check() -> void:
	if is_on_floor():
		double_jump = true
	if is_on_floor() or coyote_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			jump(jump_force)
	if not is_on_floor(): 
		if Input.is_action_just_released("jump") and velocity.y < -jump_force / 2:
			velocity.y = -jump_force / 2
	if not is_on_floor() and double_jump:
		if Input.is_action_just_pressed("jump"):
			jump(jump_force * 0.75)
			double_jump = false


func jump(force: float, create_effect: bool = true) -> void:
	velocity.y -= force
	if create_effect:
		Utils.instanstiate_to_world(JumpEffectScene, global_position)
	

func update_animations(direction: float) -> void:
	sprite_2d.scale.x = sign(get_local_mouse_position().x)
	if abs(sprite_2d.scale.x) != 1: sprite_2d.scale.x = 1
	if direction:
		animation_player.play("run")
		animation_player.speed_scale = direction * sprite_2d.scale.x 
	else:
		animation_player.play("idle")
		
	if not is_on_floor():
		animation_player.play("jump")


func die() -> void:
	camera_2d.reparent(get_tree().current_scene)
	queue_free()


func _on_drop_timer_timeout() -> void:
	set_collision_mask_value(2, true)


func _on_hurtbox_hurt(_hitbox: Variant, damage: Variant) -> void:
	print('damage on player ', self, ': ', damage)
	Events.add_screenshake.emit(3, 0.25)
	PlayerStats.health -= 1
	blink_animation_player.play('blink')
