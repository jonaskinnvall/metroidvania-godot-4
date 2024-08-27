extends HBoxContainer

@onready var label: Label = $Label

func _ready() -> void:
	_max_missiles_changed()
	update_missiles_label()
	PlayerStats.missiles_count_changed.connect(update_missiles_label)
	PlayerStats.max_missiles_changed.connect(_max_missiles_changed)

func update_missiles_label() -> void:
	label.text = str(PlayerStats.missiles)

func _max_missiles_changed() -> void:
	visible = PlayerStats.max_missiles > 0
