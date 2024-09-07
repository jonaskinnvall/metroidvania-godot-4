extends Node2D

@onready var bricks: Node2D = $Bricks
@onready var bricks_trigger: Trigger = $BricksTrigger
@onready var brick_3: Brick = $Bricks/Brick3
@onready var brick_4: Brick = $Bricks/Brick4


func _ready() -> void:
	bricks.hide()


func _on_bricks_trigger__entered() -> void:
	if not WorldStash.retrieve('first_boss', 'freed'):
		bricks.show()
		bricks_trigger.is_active = false


func _on_boss_enemy_tree_exited() -> void:
	brick_3.queue_free()
	brick_4.queue_free()
