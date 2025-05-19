class_name EntityPlayer
extends CharacterBody2D

const bulletScene: PackedScene = preload("res://entities/bullet/player/bullet.tscn")
@export var movement_speed: int = 10


@onready var character_sprite = $CharacterSprite
@onready var weapon_sprite = $CharacterSprite/CurrentWeaponSprite

func _movement(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		position.y -= movement_speed * delta
	if Input.is_action_pressed("move_down"):
		position.y += movement_speed * delta
	if Input.is_action_pressed("move_left"):
		position.x -= movement_speed * delta
	if Input.is_action_pressed("move_right"):
		position.x += movement_speed * delta

func _aim() -> float:
	var mouse_position = get_global_mouse_position()
	var texture_position = global_position
	var direction: Vector2 = mouse_position - texture_position
	var angle_rad = atan2(direction.y, direction.x)
	const THRESHOLD: float = 0.1
	if direction.x < -THRESHOLD:
		character_sprite.scale.x = -1
		weapon_sprite.scale.x = -1
		weapon_sprite.scale.y = -1
		weapon_sprite.rotation = -angle_rad
	else:
		character_sprite.scale.x = 1
		weapon_sprite.scale.x = 1
		weapon_sprite.scale.y = 1
		weapon_sprite.rotation = angle_rad
	return weapon_sprite.rotation

func _shoot(delta: float) -> void:
	var bulletNode: Node = bulletScene.instantiate()
	bulletNode.direction = position.direction_to(get_global_mouse_position()).normalized()
	bulletNode.position = character_sprite.position
	if character_sprite.scale.x == -1:
		bulletNode.rotation = -weapon_sprite.rotation
	if character_sprite.scale.x == 1:
		bulletNode.rotation = weapon_sprite.rotation

	add_child(bulletNode)

func _process(delta: float) -> void:
	_movement(delta)
	_aim()
	if Input.is_action_just_pressed("shoot_secondary_weapon"):
		_shoot(delta)
