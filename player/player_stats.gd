extends BaseStats

@export var max_missiles: int = 3: set = set_max_missiles
@onready var missiles: int = 3: set = set_missiles

signal missiles_count_changed

func set_max_missiles(value: int) -> void:
	max_missiles = value

func set_missiles(value: int) -> void:
	missiles = clampi(value, 0, max_missiles)
	missiles_count_changed.emit()
