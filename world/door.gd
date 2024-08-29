class_name Door
extends Area2D

@export_file('*.tscn') var new_level_path: String
@onready var left_cast: RayCast2D = $LeftCast
@onready var right_cast: RayCast2D = $RightCast


func _physics_process(_delta: float) -> void:
	var player: Player = MainInstances.player
	if not player is Player: return
	
	if overlaps_body(player):
		var player_direction = sign(player.velocity.x)
		if player_direction == get_direction():
			print('door entered')
			Events.door_entered.emit(self)


func get_direction() -> int:
	if left_cast.is_colliding():
		return -1
	elif right_cast.is_colliding():
		return 1
	else:
		return 0
