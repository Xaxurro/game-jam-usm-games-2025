class_name Bullet
extends CharacterBody2D

enum Targets {
	PLAYER,
	ENEMY
}

@export var speed: int
@export var direction: Vector2

func _init(position: Vector2, direction: Vector2, speed: int) -> void:
	self.position = position
	self.direction = direction
	self.speed = speed
