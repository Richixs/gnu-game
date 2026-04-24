extends Node

var current_speed: float = 200.0 
var speed_multiplier: float = 6.0 

var max_speed: float = 600.0 

func _physics_process(delta: float) -> void:
	if current_speed < max_speed:
		current_speed += speed_multiplier * delta
