extends CharacterBody2D

@export var skin: SkinData

@onready var sprite = $Sprite
@onready var collision_shape = $CollisionShape2D

const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_ducking: bool = false

func _ready():
	_apply_skin()

func _apply_skin():
	if skin and sprite:
		sprite.sprite_frames = skin.animations
		_set_collision_state(false)
		sprite.play("run")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		if not is_ducking:
			sprite.play("idle")


	if Input.is_action_just_pressed("up") and is_on_floor() and not is_ducking:
		velocity.y = JUMP_VELOCITY

	if is_on_floor():
		if Input.is_action_pressed("down"):
			if not is_ducking:
				_set_collision_state(true)
		elif is_ducking:
			_set_collision_state(false)
		else:
			sprite.play("run")

	move_and_slide()

func _set_collision_state(duck: bool):
	is_ducking = duck
	
	if not skin or not collision_shape.shape is RectangleShape2D:
		return

	if is_ducking:
		collision_shape.shape.size = skin.ducking_size
		collision_shape.position = skin.ducking_offset
		sprite.position = skin.ducking_offset
		sprite.play("duck")
	else:
		collision_shape.shape.size = skin.standing_size
		collision_shape.position = skin.standing_offset
		sprite.position = skin.standing_offset
		sprite.play("run")
