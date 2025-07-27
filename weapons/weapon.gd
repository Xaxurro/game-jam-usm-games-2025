class_name Weapon
extends Node2D

const bulletScene: PackedScene = preload("uid://c3yoxd22ehu6h")

@export var weapon_resource: WeaponResource = preload("res://weapons/resources/m60.tres")

@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cooldown: Timer = $Cooldown
@onready var sound_effect_player: AudioStreamPlayer = $SoundPlayer
@onready var muzzle_point: Marker2D = $Sprite/Muzzle

var _initial_local_position: Vector2

func set_resource(new_weapon_resource: WeaponResource) -> void:
	weapon_resource = new_weapon_resource.duplicate()
	sprite.texture = new_weapon_resource.spritesheet
	sound_effect_player.stream = new_weapon_resource.shoot_sound_effect
	cooldown.wait_time = new_weapon_resource.firerate_in_seconds

func _ready() -> void:
	set_resource(weapon_resource)
	_initial_local_position = position

	cooldown.one_shot = true
	cooldown.autostart = false

func shoot_at(target_direction: Vector2) -> void:
	if cooldown.time_left != 0: return

	if not target_direction.is_normalized():
		target_direction = target_direction.normalized()

	animation_player.play("shoot")
	sound_effect_player.play()

	var bulletNode: Bullet = bulletScene.instantiate()
	bulletNode.initial_direction = target_direction
	bulletNode.damage = weapon_resource.damage
	if get_parent() is Player and Player.euphoria.is_active:
		bulletNode.damage *= Player.euphoria.damage_multiplier

	if weapon_resource.is_enemy:
		bulletNode.target = bulletNode.TARGETS.PLAYER

	# Spawn the bullet at the front of the barrel of the shotgun
	bulletNode.global_position = muzzle_point.global_position
	bulletNode.get_node("Sprite").rotation = target_direction.angle()

	get_tree().get_root().add_child(bulletNode)
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
	var recoil_vector_local: Vector2 = recoil_direction_local * weapon_resource.max_recoil_offset * recoil_factor

	# Apply recoil at local position
	position = _initial_local_position + transform.basis_xform(recoil_vector_local)

func _process(_delta: float):
	if weapon_resource.should_do_recoil:
		_update_recoil()
