extends CharacterBody2D

@export var acceleration = 512
@export var max_velocity = 64
@export var max_fall_velocity = 128
@export var gravity = 200
@export var friction = 256
@export var jump_force = 128

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D


func _physics_process(delta):
	apply_gravity(delta)
	
	var direction = Input.get_axis("ui_left","ui_right")
	if direction:
		apply_acceleration(direction, delta)
	else: 
		apply_friction(delta)
		
	jump_check()
	update_animations(direction)
	move_and_slide()


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_velocity, gravity * delta)


func apply_acceleration(direction,delta):
	velocity.x = move_toward(velocity.x, direction * max_velocity, acceleration * delta)


func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, friction * delta)


func jump_check():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y -= jump_force
	else: 
		if Input.is_action_just_released("ui_up") and velocity.y < -jump_force / 2:
			velocity.y = -jump_force / 2


func update_animations(direction):
	if direction:
		animation_player.play("run")
		sprite_2d.scale.x = sign(direction)
	else:
		animation_player.play("idle")
		
	if not is_on_floor():
		animation_player.play("jump")