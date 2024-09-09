extends Node

const TEST_PATH: String = 'res://save.txt'
const PROD_PATH: String = 'user://metroidvania_save.save'

var save_path: String = TEST_PATH
var is_loading: bool = false

func save_to_file() -> void:
	WorldStash.stash('current_level','path', MainInstances.level.scene_file_path)
	WorldStash.stash('player', 'last_position', var_to_str(MainInstances.player.global_position))
	var save_file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_string(JSON.stringify(WorldStash.data))
	save_file.close()
	
func load_from_file() -> void:
	var save_file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
	if not save_file is FileAccess: return
	
	WorldStash.data = JSON.parse_string(save_file.get_line())
	MainInstances.world.load_level(WorldStash.retrieve('current_level', 'path'))
	MainInstances.player.global_position = str_to_var(WorldStash.retrieve('player', 'last_position'))
	save_file.close()
