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

func _aim() -> void:
	var weapon_sprite = $CharacterSprite/CurrentWeaponSprite
	var mouse_position = get_global_mouse_position()
	var texture_position = global_position
	var direction: Vector2 = mouse_position - texture_position
	var angle_rad = atan2(direction.y, direction.x)
	weapon_sprite.rotation = angle_rad
	const THRESHOLD: float = 0.1
	if direction.x < -THRESHOLD:
		weapon_sprite.scale.y = -1
	else:
		weapon_sprite.scale.y = 1

func _process(delta: float) -> void:
	_movement(delta)
	_aim()
