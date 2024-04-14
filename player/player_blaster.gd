extends Node2D

const BulletScene: PackedScene = preload('res://player/bullet.tscn')
const MissileScene: PackedScene = preload('res://player/missile.tscn')

@onready var blaster_sprite: Sprite2D = $BlasterSprite
@onready var muzzle: Marker2D = $BlasterSprite/Muzzle


func _process(_delta: float) -> void:
	blaster_sprite.rotation = get_local_mouse_position().angle()


func fire_bullet() -> void:
	var bullet: Node2D = Utils.instanstiate_to_world(BulletScene, muzzle.global_position)
	bullet.rotation = blaster_sprite.rotation
	bullet.update_velocity_based_on_rotation()


func fire_missile() -> void:
	var missile: Node2D = Utils.instanstiate_to_world(MissileScene, muzzle.global_position)
	missile.rotation = blaster_sprite.rotation
	missile.update_velocity_based_on_rotation()
