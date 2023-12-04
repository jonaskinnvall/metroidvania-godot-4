extends Node2D

@onready var blaster_sprite: Sprite2D = $BlasterSprite
@onready var muzzle: Marker2D = $BlasterSprite/Muzzle


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	blaster_sprite.rotation = get_local_mouse_position().angle()
