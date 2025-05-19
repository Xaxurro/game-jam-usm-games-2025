class_name Bullet
extends CharacterBody2D

enum Targets {
	PLAYER,
	ENEMY
}

@export var speed: int = 1000
@export var lifespan: float = 5.0
var direction: Vector2

func _ready() -> void:
	velocity = direction * speed

func move(delta: float) -> void:
	position += velocity * delta
	lifespan -= delta
	if lifespan < 0:
		queue_free()

func _process(delta: float) -> void:
	move(delta)
