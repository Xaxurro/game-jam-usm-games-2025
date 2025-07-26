class_name Enemy
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var weapon: Weapon = $Weapon
@onready var health_current: float = 30
@onready var money_on_death: int = 100
@onready var euphoria_on_death: int = 5


func _aim_at_player() -> void:
	var direction = Player.global_position - global_position
	var angle = atan2(direction.y, direction.x)

	weapon.sprite.rotation = angle

	const THRESHOLD = 0.1
	sprite.flip_h = direction.x < -THRESHOLD
	weapon.sprite.scale.y = -1 if sprite.flip_h else 1

func recieve_damage(damage_recieved: int) -> void:
	health_current -= damage_recieved
	if health_current <= 0:
		die()

func die() -> void:
	Player.inventory.add_money(money_on_death)
	Player.euphoria.add_meter(euphoria_on_death)
	queue_free()
