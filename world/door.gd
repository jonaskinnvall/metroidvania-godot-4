class_name Door
extends Area2D

@export_file('*.tscn') var new_level_path: String
@export var connection: DoorConnection
var active: bool = false
@onready var left_cast: RayCast2D = $LeftCast
@onready var right_cast: RayCast2D = $RightCast


func _physics_process(_delta: float) -> void:
	var player: Player = MainInstances.player
	if not active or not player is Player: return
	
	if overlaps_body(player) and new_level_path:
		var player_direction: int = sign(player.velocity.x)
		if player_direction == get_direction():
			Events.door_entered.emit(self)


func get_direction() -> int:
	if left_cast.is_colliding():
		return -1
	elif right_cast.is_colliding():
		return 1
	else:
		return 0


func _on_timer_timeout() -> void:
	active = true
