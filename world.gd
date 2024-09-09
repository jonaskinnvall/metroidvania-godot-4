class_name World
extends Node2D

@onready var level: Node2D = $LevelOne


func _enter_tree() -> void:
	MainInstances.world = self


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.door_entered.connect(change_levels)
	Events.player_died.connect(game_over)
	Music.play(Music.main_theme)
	if SaveManager.is_loading:
		SaveManager.load_from_file()
		SaveManager.is_loading = false


func _exit_tree() -> void:
	MainInstances.world = null


func load_level(file_path: String) -> void:
	level.queue_free()
	level.name = level.name + 'OLD'
	var new_level: Node2D = load(file_path).instantiate()
	add_child(new_level)
	level = new_level


func change_levels(door: Door) -> void:
	var player: Player = MainInstances.player
	if not player is Player: return
	
	level.queue_free()
	var next_level: Node2D = load(door.new_level_path).instantiate()
	add_child(next_level)
	level = next_level
	var doors: Array = get_tree().get_nodes_in_group('doors')
	for found_door: Door in doors:
		if found_door == door or found_door.connection != door.connection: continue
		var yoffset: float = player.global_position.y - door.global_position.y
		player.global_position = found_door.global_position + Vector2(0,yoffset)


func game_over() -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file('res://menus/game_over_menu.tscn')
