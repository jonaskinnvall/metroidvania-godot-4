extends BaseStats

@export var max_missiles: int = 0: set = set_max_missiles
@onready var missiles: int = max_missiles: set = set_missiles

signal max_missiles_changed
signal missiles_count_changed

func set_max_missiles(value: int) -> void:
	max_missiles = value
	max_missiles_changed.emit()

func set_missiles(value: int) -> void:
	missiles = clampi(value, 0, max_missiles)
	missiles_count_changed.emit()


func refill() -> void:
	health = max_health
	missiles = max_missiles


func stash_stats() -> void:
	WorldStash.stash('player', 'max_health', max_health)
	WorldStash.stash('player', 'max_missiles', max_missiles)


func retrieve_stats() -> void:
	max_health = WorldStash.retrieve('player', 'max_health')
	max_missiles = WorldStash.retrieve('player', 'max_missiles')
	refill()
