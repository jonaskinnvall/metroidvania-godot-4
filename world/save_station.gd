extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_area_2d_body_entered(_body: Node2D) -> void:
	Sound.play(Sound.powerup, 0.6, -10.0)
	animation_player.play('save')
	SaveManager.save_to_file()
