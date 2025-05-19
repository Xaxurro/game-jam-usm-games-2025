class_name Bullet
extends CharacterBody2D

enum Targets {
	PLAYER,
	ENEMY
}

@export var speed: int
var direction: Vector2

func _ready() -> void:
	velocity = rotation * speed

func _process(delta: float) -> void:
	position += velocity * delta
	pass
