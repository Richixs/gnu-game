extends Area2D

@export var speed: float = 250.0 

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _physics_process(delta: float) -> void:
	position.x -= speed * delta
	
	if position.x < -15:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("¡Colisión con: ", name, "!")
