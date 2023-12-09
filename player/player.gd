extends CharacterBody2D

const DustEffectScene: PackedScene = preload('res://effects/dust_effect.tscn')

@export var acceleration: int = 512
@export var max_velocity: int = 64
@export var max_fall_velocity: int = 128
@export var gravity: int = 200
@export var friction: int = 256
@export var jump_force: int = 128

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var player_blaster: Node2D = $PlayerBlaster
@onready var fire_rate_timer: Timer = $FireRateTimer


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	var direction: float = Input.get_axis("move_left","move_right")
	if direction:
		apply_acceleration(direction, delta)
	else: 
		apply_friction(delta)
		
	jump_check()
	
	if Input.is_action_pressed('fire') and fire_rate_timer.time_left == 0:
		fire_rate_timer.start()
		player_blaster.fire_bullet()
		
	update_animations(direction)
	
	var was_on_floor: bool = is_on_floor()
	move_and_slide()
	var just_left_edge: bool = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_edge:
		coyote_timer.start()


func create_dust_effect() -> void:
	Utils.instanstiate_to_world(DustEffectScene, global_position)


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_velocity, gravity * delta)


func apply_acceleration(direction: float,delta: float) -> void:
	velocity.x = move_toward(velocity.x, direction * max_velocity, acceleration * delta)


func apply_friction(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, friction * delta)


func jump_check() -> void:
	if is_on_floor() or coyote_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			velocity.y -= jump_force
	if not is_on_floor(): 
		if Input.is_action_just_released("jump") and velocity.y < -jump_force / 2:
			velocity.y = -jump_force / 2


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
