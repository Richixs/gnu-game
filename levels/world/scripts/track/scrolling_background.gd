extends ParallaxBackground

@export var scroll_speed: float = 250.0

func _physics_process(delta: float) -> void:
	scroll_base_offset.x -= scroll_speed * delta
