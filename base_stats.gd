class_name BaseStats
extends Node

signal no_health
signal health_changed
signal max_health_changed

@export var max_health: int = 3 : set = set_max_health
@onready var health: int = max_health : set = set_health


func set_max_health(value: int) -> void:
	max_health = value
	max_health_changed.emit()
	
	
func set_health(value: int) -> void:
	health = clamp(value, 0, max_health)
	health_changed.emit()
	if health <= 0: no_health.emit()
