extends Node2D

var state: Callable = _rush_state
@onready var boss_stats: BaseStats = $BossStats


func _process(_delta: float) -> void:
	pass


func _rush_state(_delta: float) -> void:
	pass



func _fire_state(_delta: float) -> void:
	pass


func _on_hurtbox_hurt(_hitbox: Area2D, damage: int) -> void:
	boss_stats.health -= damage


func _on_boss_stats_no_health() -> void:
	queue_free()
