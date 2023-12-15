extends Camera2D

var shake: float = 0
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.add_screenshake.connect(set_screenshake)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	offset.x = randf_range(-shake, shake)
	offset.y = randf_range(-shake, shake)


func set_screenshake(amount: float,duration: float) -> void:
	shake = amount
	timer.start(duration)


func _on_timer_timeout() -> void:
	shake = 0
