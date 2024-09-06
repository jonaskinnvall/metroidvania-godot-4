extends Node2D

@onready var bricks: Node2D = $Bricks

func _on_bricks_trigger__entered() -> void:
	bricks.show()
