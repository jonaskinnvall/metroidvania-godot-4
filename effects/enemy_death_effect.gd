extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Sound.play(Sound.enemy_die, 1.0, -10.0)
