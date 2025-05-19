class_name EntityPlayer
extends CharacterBody2D

@export var movement_speed: int = 10

func _movement(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		position.y -= movement_speed * delta
	if Input.is_action_pressed("move_down"):
		position.y += movement_speed * delta
	if Input.is_action_pressed("move_left"):
		position.x -= movement_speed * delta
	if Input.is_action_pressed("move_right"):
		position.x += movement_speed * delta

func _process(delta: float) -> void:
	_movement(delta)
