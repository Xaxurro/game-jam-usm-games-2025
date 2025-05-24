extends CharacterBody2D

@export var speed: float = 100.0
@export var stop_distance: float = 120.0
@export var shoot_distance: float = 150.0
@export var shoot_cooldown: float = 1.0

@onready var sprite: AnimatedSprite2D = $sprite
@onready var primary_weapon: Weapon = $PrimaryWeapon
@onready var weapon_sprite: Sprite2D = $PrimaryWeapon/Sprite
@onready var raycast: RayCast2D = $RayCast2D

var player: Node2D = null
var shoot_timer: float = 0.0

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		push_warning("No player found in group 'player'")

func _physics_process(delta: float) -> void:
	if player == null:
		return

	shoot_timer -= delta

	var distance = global_position.distance_to(player.global_position)

	# Movement
	if distance > stop_distance:
		sprite.play("walking")
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
	else:
		sprite.play("idle")
		velocity = Vector2.ZERO

	move_and_slide()
	_aim_at_player()

	# Shooting with raycast check
	if distance <= shoot_distance and shoot_timer <= 0:
		var direction_to_player = (player.global_position - global_position).normalized()
		
		# Update raycast to aim toward player
		raycast.target_position = direction_to_player * shoot_distance
		raycast.force_raycast_update()

		# Only shoot if no wall or obstacle is blocking the view
		if not raycast.is_colliding() or raycast.get_collider().is_in_group("player"):
			primary_weapon.shoot_at(direction_to_player)
			shoot_timer = shoot_cooldown

func _aim_at_player() -> void:
	if player == null:
		return

	var direction = player.global_position - global_position
	var angle_rad = atan2(direction.y, direction.x)

	if weapon_sprite:
		weapon_sprite.rotation = angle_rad

	const THRESHOLD = 0.1
	if direction.x < -THRESHOLD:
		sprite.flip_h = true
		if weapon_sprite:
			weapon_sprite.scale.y = -1
	else:
		sprite.flip_h = false
		if weapon_sprite:
			weapon_sprite.scale.y = 1
