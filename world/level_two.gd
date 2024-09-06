extends Node2D

@onready var bricks: Node2D = $Bricks
@onready var bricks_trigger: Trigger = $BricksTrigger

func _on_bricks_trigger__entered() -> void:
	if not WorldStash.retrieve('first_boss', 'freed'):
		bricks.show()
		bricks_trigger.is_active = false
