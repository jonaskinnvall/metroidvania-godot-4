class_name Powerup
extends Area2D


func _ready() -> void:
	await get_tree().process_frame
	if WorldStash.retrieve(WorldStash.get_id(self), "freed"):
		queue_free()
	

func pickup() -> void:
	Sound.play('powerup', 1.0, -10.0)
	WorldStash.stash(WorldStash.get_id(self), "freed", true)
	queue_free()


func _on_body_entered(_body: Node2D) -> void:
	pickup()
