extends Node

var sounds_path: String = 'res://music_and_sounds/'
@onready var sound_players: Array[Node] = get_children()


func play(sound_name: String, pitch_scale: float = 1.0, volume_db: float = 0.0) -> void:
	for sound_player: AudioStreamPlayer in sound_players:
		if not sound_player.playing:
			sound_player.pitch_scale =  pitch_scale
			sound_player.volume_db =  volume_db
			sound_player.stream = load(sounds_path + sound_name + '.wav')
			sound_player.play()
			return
