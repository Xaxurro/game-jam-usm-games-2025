class_name EntityPlayer
extends CharacterBody2D

const bulletScene: PackedScene = preload("res://entities/bullet/player/bullet.tscn")
@export var movement_speed: int = 10


@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var shotgun: Sprite2D = $Shotgun
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var shoot_cooldown: Timer = $Shotgun/Cooldown

func _movement(delta: float) -> void:
	var new_direction: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		new_direction.y = movement_speed * delta * -1
	if Input.is_action_pressed("move_down"):
		new_direction.y = movement_speed * delta
	if Input.is_action_pressed("move_left"):
		new_direction.x = movement_speed * delta * -1
	if Input.is_action_pressed("move_right"):
		new_direction.x = movement_speed * delta
	
	if new_direction == Vector2.ZERO:
		_animation_player.play("idle")
	else:
		_animation_player.play("running")
	
	position += new_direction

# Gets the mouse position and changes the rotation of the character + the weapon to point at the mouse
func _aim() -> void:
	var mouse_position = get_global_mouse_position()
	var texture_position = global_position
	var direction: Vector2 = mouse_position - texture_position
	var angle_rad = atan2(direction.y, direction.x)
	shotgun.rotation = angle_rad

	const THRESHOLD: float = 0.1
	# Aim left
	if direction.x < -THRESHOLD:
		character_sprite.scale.x = -1
		shotgun.scale.y = -1			#Without this the shotgun looks inverted
	# Aim right
	else:
		character_sprite.scale.x = 1
		shotgun.scale.y = 1


func _shoot(delta: float) -> void:
	# Execute code only when pressed right click and is not on cooldown
	if not Input.is_action_just_pressed("shoot_secondary_weapon"): return
	if shoot_cooldown.time_left != 0: return

	$Shotgun/AnimationPlayer.play("shoot")
	$Shotgun/SoundEffect.play()

	var bulletNode: Bullet = bulletScene.instantiate()

	bulletNode.direction = position.direction_to(get_global_mouse_position()).normalized()

	# Spawn the bullet at the front of the barrel of the shotgun
	bulletNode.position = character_sprite.position + (bulletNode.direction * bulletNode.speed * delta)
	bulletNode.rotation = shotgun.rotation 

	add_child(bulletNode)
	shoot_cooldown.start()

func _update_recoil() -> void:
	# Set to original position
	if shoot_cooldown.paused or shoot_cooldown.wait_time <= 0:
		shotgun.position = character_sprite.position
		return

	var max_recoil_offset: float = 15.0
	var recoil_factor: float = shoot_cooldown.time_left / shoot_cooldown.wait_time

	# Backwards direction
	var recoil_direction_local: Vector2 = Vector2(-1, 0)
	# Apply recoil offset and factor
	var recoil_vector_local: Vector2 = recoil_direction_local * max_recoil_offset * recoil_factor

	# Apply recoil at local position
	shotgun.position = character_sprite.position + shotgun.transform.basis_xform(recoil_vector_local)

func _process(delta: float) -> void:
	_movement(delta)
	_aim()
	_shoot(delta)
	_update_recoil()
