extends CharacterBody2D

@export var skin: SkinData

@onready var sprite = $Sprite

const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	_apply_skin()

func _apply_skin():
	if skin and sprite:
		sprite.sprite_frames = skin.animations
		sprite.play("run")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()
