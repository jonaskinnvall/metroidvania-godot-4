extends Node

@export var bullet: AudioStream
@export var click: AudioStream
@export var enemy_die: AudioStream
@export var explosion: AudioStream
@export var hurt: AudioStream
@export var jump: AudioStream
@export var pause: AudioStream
@export var powerup: AudioStream
@export var step: AudioStream
@export var unpause: AudioStream
@onready var sound_players: Array[Node] = get_children()


func play(sound_stream: AudioStream, pitch_scale: float = 1.0, volume_db: float = 0.0) -> void:
	for sound_player: AudioStreamPlayer in sound_players:
		if not sound_player.playing:
			sound_player.pitch_scale =  pitch_scale
			sound_player.volume_db =  volume_db
			sound_player.stream = sound_stream
			sound_player.play()
			return
	print('Too many sound streams playing at same time')
