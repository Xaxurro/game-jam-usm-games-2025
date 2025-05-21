class_name Weapon
extends Node2D

const bulletScene: PackedScene = preload("res://entities/bullet/player/bullet.tscn")

@export var should_do_recoil: bool = true

@onready var _muzzle_point: Marker2D = $Sprite/Muzzle

var _initial_local_position: Vector2

func _ready() -> void:
	_initial_local_position = position

func shoot_at(target_direction: Vector2) -> void:
	if $Cooldown.time_left != 0: return

	$AnimationPlayer.play("shoot")
	$SoundEffect.play()

	var bulletNode: Bullet = bulletScene.instantiate()

	bulletNode.direction = target_direction

	# Spawn the bullet at the front of the barrel of the shotgun
	bulletNode.global_position = _muzzle_point.global_position
	bulletNode.get_node("Sprite").rotation = target_direction.angle()

	get_tree().get_root().add_child(bulletNode)
	$Cooldown.start()
func _update_recoil() -> void:
	# Set to original position
	if $Cooldown.paused or $Cooldown.wait_time <= 0:
		position = _initial_local_position
		return

	var max_recoil_offset: float = 15.0
	var recoil_factor: float = $Cooldown.time_left / $Cooldown.wait_time

	# Backwards direction
	var recoil_direction_local: Vector2 = Vector2(-1, 0).rotated($Sprite.rotation)
	# Apply recoil offset and factor
	var recoil_vector_local: Vector2 = recoil_direction_local * max_recoil_offset * recoil_factor

	# Apply recoil at local position
	position = _initial_local_position + transform.basis_xform(recoil_vector_local)

func _process(_delta):
	if should_do_recoil:
		_update_recoil()
