extends Node2D


func instantiate_to_world(scene: PackedScene, scene_position: Vector2) -> Node2D:
	var world: Node2D = get_tree().current_scene
	var instance: Node2D = scene.instantiate()
	
	world.add_child(instance)
	instance.global_position = scene_position
	
	return instance


func instantiate_to_level(scene: PackedScene, scene_position: Vector2) -> Node2D:
	var world: Node2D = get_tree().current_scene
	if not world is World: return
	var level: Node2D = world.level
	var instance: Node2D = scene.instantiate()
	
	level.add_child.call_deferred(instance)
	instance.global_position = scene_position
	
	return instance
