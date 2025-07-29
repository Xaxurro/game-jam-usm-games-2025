class_name Weapon
extends Node2D

@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cooldown: Timer = $Cooldown
@onready var sound_effect_player: AudioStreamPlayer = $SoundPlayer
@onready var muzzle_point: Marker2D = $Sprite/Muzzle

@export_group("Shoot")
@export var bullet_type: Bullet.TYPE = Bullet.TYPE.NORMAL
@export var is_enemy: bool = true
@export var damage: float = 10
@export var firerate_in_seconds: float = 0.5
@export_subgroup("Recoil")
@export var should_do_recoil: bool = true
@export var max_recoil_offset: float = 15.0

var _initial_local_position: Vector2

func _ready() -> void:
	_initial_local_position = position

	cooldown.wait_time = firerate_in_seconds

func instantiate_bullet(target_direction: Vector2) -> Bullet:
	var bullet_node: Bullet = load(Constants.SCENES_PATHS[bullet_type]).instantiate()
	bullet_node.initial_direction = target_direction
	bullet_node.damage = damage
	if get_parent() is Player and Player.euphoria.is_active:
		bullet_node.damage *= Player.euphoria.damage_multiplier

	if not get_parent() is Player:
		bullet_node.target = bullet_node.TARGETS.PLAYER

	# Spawn the bullet at the front of the barrel of the shotgun
	bullet_node.global_position = muzzle_point.global_position
	bullet_node.get_node("Sprite").rotation = target_direction.angle()
	return bullet_node

## Shoots at the given direction
func shoot_at(target_direction: Vector2) -> void:
	if cooldown.time_left != 0: return

	if not target_direction.is_normalized():
		target_direction = target_direction.normalized()

	if not animation_player.has_animation("shoot"): push_error("WEAPON %s IS MISSING SHOOT ANIMATION")
	else: animation_player.play("shoot")
	if sound_effect_player.stream == null: push_error("WEAPON %s IS MISSING SHOOT SOUND EFFECT")
	else: sound_effect_player.play()

	var bullet_node: Bullet = instantiate_bullet(target_direction)

	get_tree().get_root().add_child(bullet_node)
	cooldown.start()

func _update_recoil() -> void:
	# Set to original position
	if cooldown.paused or cooldown.wait_time <= 0:
		position = _initial_local_position
		return

	var recoil_factor: float = cooldown.time_left / cooldown.wait_time

	# Backwards direction
	var recoil_direction_local: Vector2 = Vector2(-1, 0).rotated(sprite.rotation)
	# Apply recoil offset and factor
	var recoil_vector_local: Vector2 = recoil_direction_local * max_recoil_offset * recoil_factor

	# Apply recoil at local position
	position = _initial_local_position + transform.basis_xform(recoil_vector_local)

func _process(_delta: float):
	if should_do_recoil:
		_update_recoil()
