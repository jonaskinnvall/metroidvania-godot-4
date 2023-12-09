extends Node2D


func instanstiate_to_world(scene: PackedScene, position: Vector2) -> Node2D:
	var instance: Node2D = scene.instantiate()
	var world: Node2D = get_tree().current_scene
	
	world.add_child(instance)
	instance.global_position = position
	
	return instance
