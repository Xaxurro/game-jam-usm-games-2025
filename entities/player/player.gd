class_name EntityPlayer
extends CharacterBody2D

const bulletScene: PackedScene = preload("res://entities/bullet/player/bullet.tscn")
@export var movement_speed: int = 10


@onready var character_sprite = $CharacterSprite
@onready var weapon_sprite = $CharacterSprite/CurrentWeaponSprite
@onready var shoot_cooldown: Timer = $ShootCooldown

func _movement(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		position.y -= movement_speed * delta
	if Input.is_action_pressed("move_down"):
		position.y += movement_speed * delta
	if Input.is_action_pressed("move_left"):
		position.x -= movement_speed * delta
	if Input.is_action_pressed("move_right"):
		position.x += movement_speed * delta

# Gets the mouse position and changes the rotation of the character + the weapon to point at the mouse
func _aim() -> void:
	var mouse_position = get_global_mouse_position()
	var texture_position = global_position
	var direction: Vector2 = mouse_position - texture_position
	var angle_rad = atan2(direction.y, direction.x)
	const THRESHOLD: float = 0.1
	# Aim left
	if direction.x < -THRESHOLD:
		character_sprite.scale.x = -1
		weapon_sprite.scale.x = -1
		weapon_sprite.scale.y = -1
		weapon_sprite.rotation = -angle_rad
	# Aim right
	else:
		character_sprite.scale.x = 1
		weapon_sprite.scale.x = 1
		weapon_sprite.scale.y = 1
		weapon_sprite.rotation = angle_rad

func _shoot(delta: float) -> void:
	# Execute code only when pressed right click and is not on cooldown
	if not Input.is_action_just_pressed("shoot_secondary_weapon"): return
	if shoot_cooldown.time_left != 0: return

	var bulletNode: Bullet = bulletScene.instantiate()

	bulletNode.direction = position.direction_to(get_global_mouse_position()).normalized()

	# Spawn the bullet at the front of the barrel of the shotgun
	bulletNode.position = character_sprite.position + (bulletNode.direction * bulletNode.speed * delta)
	if character_sprite.scale.x == -1:
		bulletNode.rotation = -weapon_sprite.rotation
	if character_sprite.scale.x == 1:
		bulletNode.rotation = weapon_sprite.rotation

	add_child(bulletNode)
	shoot_cooldown.start()

func _update_recoil() -> void:
	if shoot_cooldown.paused or shoot_cooldown.wait_time <= 0:
		weapon_sprite.position = character_sprite.position
		return

	var max_recoil_offset: float = 15.0
	var recoil_factor: float = shoot_cooldown.time_left / shoot_cooldown.wait_time

	# Backwards direction
	var recoil_direction_local: Vector2 = Vector2(-1, 0)
	# transform it into a Vector2
	var recoil_vector_local: Vector2 = recoil_direction_local * max_recoil_offset * recoil_factor

	# Apply recoil at local position
	weapon_sprite.position = character_sprite.position + weapon_sprite.transform.basis_xform(recoil_vector_local)

func _process(delta: float) -> void:
	_movement(delta)
	_aim()
	_shoot(delta)
	_update_recoil()
