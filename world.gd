class_name World
extends Node2D

@onready var level: Node2D = $LevelOne


func _enter_tree() -> void:
	MainInstances.world = self


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.door_entered.connect(change_levels)
	Music.play(Music.main_theme)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('save'):
		SaveManager.save_to_file()
	if Input.is_action_just_pressed('load'):
		SaveManager.load_from_file()

func _exit_tree() -> void:
	MainInstances.world = null


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
