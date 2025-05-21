class_name Bullet
extends CharacterBody2D

enum Targets {
	PLAYER,
	ENEMY
}

@export var speed: int = 1000
@export var damage: int = 10
@export var lifespan_in_seconds: float = 5.0
var direction: Vector2

func _ready() -> void:
	velocity = direction * speed

func move(delta: float) -> void:
	# Delete the bullet if got past lifespan
	lifespan_in_seconds -= delta
	if lifespan_in_seconds < 0:
		queue_free()
	position += velocity * delta

func _process(delta: float) -> void:
	move(delta)
