extends Enemy

@export var stats: Stats = preload("res://entities/enemies/fbi-agents/stage-1/resources/normal.tres")


var last_known_player_position: Vector2 = Vector2.ZERO
var has_seen_player: bool = false

func _ready() -> void:
	stats = stats.duplicate()
	health_current = stats.health_current
	money_on_death = stats.money_on_death
	euphoria_on_death = stats.euphoria_on_death
	setup_navigation()

func _physics_process(delta: float) -> void:
	var sees_player = can_detect_player()
	shoot_timer -= delta

	var distance = global_position.distance_to(last_known_player_position)

	if sees_player:
		distance = global_position.distance_to(Player.global_position)
		update_movement_and_navigation(distance, delta, Player.global_position)
		_aim_at_player()
		handle_shooting(distance)
		move_and_slide()
		return

	if not has_seen_player: return

	if distance > 8.0:
		update_movement_and_navigation(distance, delta, last_known_player_position)
	else:
		sprite.play("idle")
		velocity = Vector2.ZERO
		has_seen_player = false 
	move_and_slide()


func setup_navigation() -> void:
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = stats.stop_distance

func can_detect_player() -> bool:
	var distance = global_position.distance_to(Player.global_position)
	if distance > stats.detection_range:
		return false

	var direction = (Player.global_position - global_position).normalized()
	raycast.target_position = direction * stats.detection_range
	raycast.force_raycast_update()

	var collider = raycast.get_collider()
	if collider and collider.is_in_group("player"):
		last_known_player_position = Player.global_position
		has_seen_player = true
		return true

	return false

func update_movement_and_navigation(distance: float, delta: float, target_position: Vector2) -> void:
	if distance <= stats.stop_distance:
		sprite.play("idle")
		velocity = Vector2.ZERO
		return

	sprite.play("walking")
	nav_agent.target_position = target_position

	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	var desired_velocity = direction * stats.speed
	velocity = velocity.lerp(desired_velocity, stats.acceleration * delta / stats.speed)

func handle_shooting(distance: float) -> void:
	if distance > stats.shoot_distance or shoot_timer > 0: return

	var direction = (Player.global_position - global_position).normalized()

	raycast.target_position = direction * stats.shoot_distance
	raycast.force_raycast_update()

	if not raycast.is_colliding() or (raycast.get_collider() is Player):
		weapon.shoot_at(direction)
		shoot_timer = stats.shoot_cooldown
