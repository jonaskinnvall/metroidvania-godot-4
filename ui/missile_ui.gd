extends HBoxContainer

@onready var label: Label = $Label

func _ready() -> void:
	update_missiles_label()
	PlayerStats.missiles_count_changed.connect(update_missiles_label)

func update_missiles_label() -> void:
	label.text = str(PlayerStats.missiles)
