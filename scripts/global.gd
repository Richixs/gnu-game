extends Node

var current_speed: float = 200.0 
var speed_multiplier: float = 6.0 
var max_speed: float = 600.0 
var actual_score: float = 0.0 
var game_active: bool = false
var is_restarting: bool = false 

signal score_updated(new_score)
signal game_over_triggered

func _physics_process(delta: float) -> void:
	if game_active:
		if current_speed < max_speed:
			current_speed += speed_multiplier * delta
		actual_score += current_speed * delta * 0.1 
		score_updated.emit(int(actual_score))

func reset_game():
	current_speed = 200.0
	actual_score = 0.0
	game_active = true
	get_tree().paused = false
	score_updated.emit(0)