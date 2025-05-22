class_name Weapon
extends Node2D

const bulletScene: PackedScene = preload("res://entities/bullet/player/bullet.tscn")

@export var damage: int = 10
@export var firerate_in_seconds: float = 0.5
@export var should_do_recoil: bool = true
@export var max_recoil_offset: float = 15.0
@export var shoot_sound_effect: AudioStream
@export var bullet_scene: PackedScene

@onready var _sprite: Sprite2D = $Sprite
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _cooldown: Timer = $Cooldown
@onready var _sound_effect_player: AudioStreamPlayer = $SoundPlayer
@onready var _muzzle_point: Marker2D = $Sprite/Muzzle

var _initial_local_position: Vector2

func _ready() -> void:
	_initial_local_position = position

	_sound_effect_player.stream = shoot_sound_effect
	_cooldown.wait_time = firerate_in_seconds
	_cooldown.one_shot = true
	_cooldown.autostart = false

func shoot_at(target_direction: Vector2) -> void:
	if _cooldown.time_left != 0: return

	_animation_player.play("shoot")
	_sound_effect_player.play()

	var bulletNode: Bullet = bulletScene.instantiate()
	bulletNode.initial_direction = target_direction
	bulletNode.damage = damage

	# Spawn the bullet at the front of the barrel of the shotgun
	bulletNode.global_position = _muzzle_point.global_position
	bulletNode.get_node("Sprite").rotation = target_direction.angle()

	get_tree().get_root().add_child(bulletNode)
	_cooldown.start()

func _update_recoil() -> void:
	# Set to original position
	if _cooldown.paused or _cooldown.wait_time <= 0:
		position = _initial_local_position
		return

	var recoil_factor: float = _cooldown.time_left / _cooldown.wait_time

	# Backwards direction
	var recoil_direction_local: Vector2 = Vector2(-1, 0).rotated(_sprite.rotation)
	# Apply recoil offset and factor
	var recoil_vector_local: Vector2 = recoil_direction_local * max_recoil_offset * recoil_factor

	# Apply recoil at local position
	position = _initial_local_position + transform.basis_xform(recoil_vector_local)

func _process(_delta: float):
	if should_do_recoil:
		_update_recoil()
