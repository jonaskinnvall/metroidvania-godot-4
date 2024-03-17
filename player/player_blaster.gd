extends Node2D

const BulletScene: PackedScene = preload('res://player/bullet.tscn')

@onready var blaster_sprite: Sprite2D = $BlasterSprite
@onready var muzzle: Marker2D = $BlasterSprite/Muzzle


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	blaster_sprite.rotation = get_local_mouse_position().angle()


func fire_bullet() -> void:
	var bullet: Node2D = Utils.instanstiate_to_world(BulletScene, muzzle.global_position)
	bullet.rotation = blaster_sprite.rotation
	bullet.update_velocity_based_on_rotation()
	
