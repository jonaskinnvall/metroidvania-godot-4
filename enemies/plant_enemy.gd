extends Node2D

@onready var base_stats: BaseStats = $BaseStats


func _on_hurtbox_hurt(hitbox: Area2D, damage: int) -> void:
	base_stats.health -= damage


func _on_base_stats_no_health() -> void:
	queue_free()
