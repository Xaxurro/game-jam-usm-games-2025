class_name Bullet
extends CharacterBody2D

enum Targets {
	PLAYER,
	ENEMY
}

@export var speed: int

func _init() -> void:
	self.speed = speed

func _process(delta: float) -> void:

	pass
