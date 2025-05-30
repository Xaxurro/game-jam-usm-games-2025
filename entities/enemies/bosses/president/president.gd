extends CharacterBody2D

@export var health_current: int = 100
@export var speed: float = 100.0
@export var stop_distance: float = 120.0
@export var shoot_distance: float = 150.0
@export var shoot_cooldown: float = 0.5
@export var acceleration: float = 500.0
@export var detection_range: float = 200.0

@export var windup_duration: float = 1.0
@export var burst_duration: float = 10.0
@export var recovery_duration: float = 5.0

@onready var sprite: AnimatedSprite2D = $sprite
@onready var primary_weapon: Weapon = $Weapon
@onready var weapon_sprite: Sprite2D = $Weapon/Sprite
@onready var raycast: RayCast2D = $RayCast2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var windup_sound: AudioStreamPlayer2D = $WindupSound 

var player: Node2D = null
var shoot_timer: float = 0.0

var burst_timer: float = 0.0
var recovery_timer: float = 0.0
var windup_timer: float = 0.0

var is_winding_up: bool = false
var is_bursting: bool = false
var is_in_recovery: bool = false

var last_known_player_position: Vector2 = Vector2.ZERO
var has_seen_player: bool = false

func _ready() -> void:
	player = get_player()
	if not player:
		push_warning("No player found in group 'player'")
	setup_navigation()

func _physics_process(delta: float) -> void:
	if not player:
		return

	var sees_player = can_detect_player()
	shoot_timer -= delta

	if sees_player:
		var distance = global_position.distance_to(player.global_position)

		if not is_in_recovery and not is_winding_up:
			update_movement_and_navigation(distance, delta, player.global_position)
		else:
			velocity = Vector2.ZERO
			sprite.play("idle")

		_aim_at_player()
		handle_shooting(distance, delta)
	else:
		if has_seen_player:
			var distance = global_position.distance_to(last_known_player_position)
			if distance > 8.0 and not is_in_recovery and not is_winding_up:
				update_movement_and_navigation(distance, delta, last_known_player_position)
			else:
				sprite.play("idle")
				velocity = Vector2.ZERO
				has_seen_player = false

	move_and_slide()

func get_player() -> Node2D:
	var players = get_tree().get_nodes_in_group("player")
	return players[0] if players.size() > 0 else null

func setup_navigation() -> void:
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = stop_distance

func can_detect_player() -> bool:
	var distance = global_position.distance_to(player.global_position)
	if distance > detection_range:
		return false

	var direction = (player.global_position - global_position).normalized()
	raycast.target_position = direction * detection_range
	raycast.force_raycast_update()

	var collider = raycast.get_collider()
	if collider and collider.is_in_group("player"):
		last_known_player_position = player.global_position
		has_seen_player = true
		return true

	return false

func update_movement_and_navigation(distance: float, delta: float, target_position: Vector2) -> void:
	if distance > stop_distance:
		sprite.play("idle")
		nav_agent.target_position = target_position

		if not nav_agent.is_navigation_finished():
			var next_pos = nav_agent.get_next_path_position()
			var direction = (next_pos - global_position).normalized()
			var desired_velocity = direction * speed
			velocity = velocity.lerp(desired_velocity, acceleration * delta / speed)
		else:
			velocity = Vector2.ZERO
	else:
		sprite.play("idle")
		velocity = Vector2.ZERO

func handle_shooting(distance: float, delta: float) -> void:
	if distance > shoot_distance:
		return

	if is_winding_up:
		windup_timer -= delta
		if windup_timer <= 0:
			is_winding_up = false
			is_bursting = true
			burst_timer = burst_duration
			shoot_timer = 0.0
	elif is_bursting:
		burst_timer -= delta
		shoot_timer -= delta

		if burst_timer <= 0:
			is_bursting = false
			is_in_recovery = true
			recovery_timer = recovery_duration
		elif shoot_timer <= 0:
			var direction = (player.global_position - global_position).normalized()
			raycast.target_position = direction * shoot_distance
			raycast.force_raycast_update()

			if not raycast.is_colliding() or raycast.get_collider().is_in_group("player"):
				primary_weapon.shoot_at(direction)
				shoot_timer = shoot_cooldown

	elif is_in_recovery:
		recovery_timer -= delta
		if recovery_timer <= 0:
			is_in_recovery = false
			start_windup()
	else:
		start_windup()

func start_windup() -> void:
	
	is_winding_up = true
	windup_timer = windup_duration
	if windup_sound and not windup_sound.playing:
		windup_sound.play()

func _aim_at_player() -> void:
	if not player:
		return

	var direction = player.global_position - global_position
	var angle = atan2(direction.y, direction.x)

	if weapon_sprite:
		weapon_sprite.rotation = angle

	const THRESHOLD = 0.1
	sprite.flip_h = direction.x < -THRESHOLD
	if weapon_sprite:
		weapon_sprite.scale.y = -1 if sprite.flip_h else 1

func recieve_damage(damage_recieved: int) -> void:
	health_current -= damage_recieved
	if health_current <= 0:
		queue_free()
