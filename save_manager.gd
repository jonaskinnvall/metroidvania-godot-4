extends Node

const TEST_PATH: String = 'res://save.txt'
const PROD_PATH: String = 'user://metroidvania_save.save'

var save_path: String = TEST_PATH

func save_to_file() -> void:
	var save_file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_string(JSON.stringify(WorldStash.data))
	save_file.close()
	
func load_from_file() -> void:
	var save_file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
	WorldStash.data = JSON.parse_string(save_file.get_as_text())
	save_file.close()
