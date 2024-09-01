extends Node

var data: Dictionary = {}


func get_id(node: Node2D) -> String:
	var world: World = get_tree().current_scene
	if not world is World: return ""
	var level: Node2D = world.level
	
	return level.name + "_" + node.name + "_" + str(node.global_position)


func stash(id: String, key: String, value: bool) -> void:
	data[id] = {}
	data[id][key] = value


func retrieve(id: String, key: String) -> bool:
	if not data.has(id): return false
	if not data[id].has(key): return false
	
	return data[id][key]
	
