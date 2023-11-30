extends CharacterBody2D

@export var acceleration = 512
@export var max_velocity = 64
@export var max_fall_velocity = 128
@export var gravity = 200
@export var friction = 256
@export var jump_force = 128


func _physics_process(delta):
	apply_gravity(delta)
	
	var direction = Input.get_axis("ui_left","ui_right")
	if direction:
		apply_acceleration(direction, delta)
	else: 
		apply_friction(delta)
		
	jump_check()
	move_and_slide()


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_velocity, gravity * delta)


func apply_acceleration(direction,delta):
	velocity.x = move_toward(velocity.x, direction * max_velocity, acceleration * delta)


func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, friction * delta)


func jump_check():
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y -= jump_force
