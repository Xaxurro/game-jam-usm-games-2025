class_name RobotEntity
extends CharacterBody2D

@export var is_active: bool = false
@export var health: int = 200
@export var speed_rushing: float = 500
@export var damage_contact: int = 25
@export var time_between_blaster_shots: float = 0.2
@export var player: Player

@onready var _blaster: Array[Weapon] = [
	$Blasters/Blaster1,
	$Blasters/Blaster2,
	$Blasters/Blaster3,
	$Blasters/Blaster4
]
var _current_blaster_index: int = 0

@onready var rush_collision_shape = $RushCollision/CollisionShape

enum ATTACK {
	NONE,
	RUSH,
	SHOOT
}

var current_attack: ATTACK = ATTACK.NONE
var target_position: Vector2

func _set_target_position() -> void:
	target_position = player.global_position

	var new_attack: int = randi() % 2
	if new_attack == 0:
		current_attack = ATTACK.RUSH
	if new_attack == 1:
		current_attack = ATTACK.SHOOT

func _attack_rush() -> void:
	rush_collision_shape.disabled = false
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed_rushing#* _delta
	move_and_slide()

	const THRESHOLD_IN_PIXELS: int = 10
	if global_position.distance_to(target_position) <= THRESHOLD_IN_PIXELS:
		rush_collision_shape.disabled = true
		current_attack = ATTACK.NONE
		velocity = Vector2.ZERO

func _attack_shoot() -> void:
	if $Cooldown.time_left != 0: return
	_blaster[_current_blaster_index].shoot_at(target_position - global_position)
	_current_blaster_index += 1
	if _current_blaster_index < _blaster.size():
		$Cooldown.start()
		return
	_current_blaster_index = 0
	current_attack = ATTACK.NONE

func _process(_delta: float) -> void:
	if not is_active: return
	match current_attack:
		ATTACK.NONE: 
			_set_target_position()
		ATTACK.RUSH:
			_attack_rush()
		ATTACK.SHOOT:
			_attack_shoot()
	return

func recieve_damage(damage: int, _direction: Vector2) -> void:
	health -= damage
	if health <= 0:
		queue_free()


func _on_cooldown_timeout() -> void:
	_attack_shoot()


func _on_rush_collision_body_entered(body:Node2D) -> void:
	if body is Player:
		Player.change_health(-damage_contact)
