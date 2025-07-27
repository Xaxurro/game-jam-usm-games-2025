class_name GrenadeBullet
extends RigidBody2D

@onready var timer: Timer = $Lifetime

@export var speed: float = 10
@export var damage: int = 10
@export var lifespan_seconds: float = 1.0

const EXPLOSION_SCENE: PackedScene = preload("uid://sy8t720vk3tn")

func _explode() -> void:
	visible = false
	var explosion: Explosion = EXPLOSION_SCENE.instantiate()
	explosion.global_position = global_position
	add_sibling(explosion)
	queue_free()

func _ready() -> void:
	linear_velocity = Player.get_global_mouse_position().normalized() * speed
	timer.wait_time = lifespan_seconds
	timer.timeout.connect(_explode)
