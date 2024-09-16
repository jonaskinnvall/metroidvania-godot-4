extends Node2D

const BulletScene: PackedScene = preload('res://player/bullet.tscn')
const MissileScene: PackedScene = preload('res://player/missile.tscn')

@export var mouse_speed: int = 15

@onready var blaster_sprite: Sprite2D = $BlasterSprite
@onready var muzzle: Marker2D = $BlasterSprite/Muzzle


func _process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	get_viewport().warp_mouse(mouse_pos + Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down") * mouse_speed)
	
	blaster_sprite.rotation = get_local_mouse_position().angle()


func fire_bullet() -> void:
	var bullet: Node2D = Utils.instantiate_to_level(BulletScene, muzzle.global_position)
	bullet.rotation = blaster_sprite.rotation
	bullet.update_velocity_based_on_rotation()


func fire_missile() -> void:
	var missile: Node2D = Utils.instantiate_to_level(MissileScene, muzzle.global_position)
	missile.rotation = blaster_sprite.rotation
	missile.update_velocity_based_on_rotation()
