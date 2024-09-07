extends Projectile


func _ready() -> void:
	Sound.play(Sound.explosion)


func _on_hitbox_body_entered(body: Node2D) -> void:
	super(body)
	
	if body is Brick:
		body.queue_free()
