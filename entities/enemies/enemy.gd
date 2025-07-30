class_name Enemy
extends CharacterBody2D

@export var resource: EnemyResource

@export var health_current: float = 30
@export var detection_range: float = 300
@export var stop_distance: float = 40
@export var speed: float = 100
@export var acceleration: float = 400
@export var shoot_distance: float = 250
@export var shoot_cooldown: float = 1.5
@export var money_on_death: int = 100
@export var euphoria_on_death: int = 5
@export var knockback_strength = 200
@export var knockback_decay: float = 20
@export var weapon_type: Weapon.TYPE = Weapon.TYPE.M60

## Para asignarle un Sprite debes crear un nodo con la animación del sprite y crearle dos animaciones 
## 'idle' y 'walking'
@export var sprite: AnimatedSprite2D
@onready var sprite_holder: Node2D = $SpriteHolder

@onready var raycast: RayCast2D = $RayCast2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var shoot_timer: float = 0.0
var last_known_player_position: Vector2 = Vector2.ZERO
var has_seen_player: bool = false
var weapon: Weapon

var knockback_velocity: Vector2 = Vector2.ZERO

func initialize(cloned_sprite: AnimatedSprite2D) -> void:
	sprite = cloned_sprite
	if not sprite:
		push_error('Recuerda agregar un Sprite ;3')
	else:
		sprite_holder.add_child(cloned_sprite)
		sprite.position = Vector2.ZERO
		sprite.z_index = 0
	sprite_holder.z_index = 0
	weapon.z_index = 1
	if weapon.has_node("sprite"):
		weapon.get_node("sprite").z_index = 1
	

func _ready() -> void:
	_set_resource_data()
	sprite.show_behind_parent = true
	setup_navigation()

func _set_resource_data() -> void:
	health_current = resource.health_current
	detection_range = resource.detection_range
	stop_distance = resource.stop_distance
	speed = resource.speed
	acceleration = resource.acceleration
	shoot_distance = resource.shoot_distance
	shoot_cooldown = resource.shoot_cooldown
	money_on_death = resource.money_on_death
	euphoria_on_death = resource.euphoria_on_death
	knockback_strength = resource.knockback_strength
	knockback_decay = resource.knockback_decay
	weapon = load(Constants.SCENES_PATHS.weapon[weapon_type]).instantiate()
	add_child(weapon)

func _physics_process(delta: float) -> void:
	var sees_player = can_detect_player()
	shoot_timer -= delta
	
	if knockback_velocity.length() > 1:
		velocity += knockback_velocity
		knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, knockback_decay * delta)
	else:
		knockback_velocity = Vector2.ZERO
	
	var distance = global_position.distance_to(last_known_player_position)

	if sees_player:
		distance = global_position.distance_to(Player.global_position)
		update_movement_and_navigation(distance, delta, Player.global_position)
		_aim_at_player()
		handle_shooting(distance)
		move_and_slide()
		return

	if not has_seen_player:
		return

	if distance > 8.0:
		update_movement_and_navigation(distance, delta, last_known_player_position)
	else:
		if sprite:
			sprite.play("idle")
		velocity = Vector2.ZERO
		has_seen_player = false

	move_and_slide()

func setup_navigation() -> void:
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = stop_distance

## Detección y raycasting
func can_detect_player() -> bool:
	var distance = global_position.distance_to(Player.global_position)
	if distance > detection_range:
		return false

	var direction = (Player.global_position - global_position).normalized()
	raycast.target_position = direction * detection_range
	raycast.force_raycast_update()

	var collider = raycast.get_collider()
	if collider and collider.is_in_group("player"):
		last_known_player_position = Player.global_position
		has_seen_player = true
		return true

	return false

## Sistema de navegación
func update_movement_and_navigation(distance: float, delta: float, target_position: Vector2) -> void:
	if distance <= stop_distance:
		if sprite:
			sprite.play("idle")
		velocity = Vector2.ZERO
		return

	if sprite:
		sprite.play("walking")

	nav_agent.target_position = target_position

	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	var desired_velocity = direction * speed
	velocity = velocity.lerp(desired_velocity, acceleration * delta / speed)

## Control de disparo según distancia
func handle_shooting(distance: float) -> void:
	if distance > shoot_distance or shoot_timer > 0:
		return

	var direction = (Player.global_position - global_position).normalized()
	raycast.target_position = direction * shoot_distance
	raycast.force_raycast_update()

	if not raycast.is_colliding() or (raycast.get_collider() is Player):
		weapon.shoot_at(direction)
		shoot_timer = shoot_cooldown

## Apuntar y mirar al jugador
func _aim_at_player() -> void:
	var direction = Player.global_position - global_position
	var angle = atan2(direction.y, direction.x)

	weapon.sprite.rotation = angle
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

## Recibir daño con knockback
func recieve_damage(damage_received: int, hit_direction: Vector2) -> void:
	health_current -= damage_received
	_apply_knockback(hit_direction)
	if health_current <= 0:
		die()

func _apply_knockback(direction: Vector2) -> void:
	knockback_velocity = direction.normalized() * knockback_strength

func die() -> void:
	Player.inventory.add_money(money_on_death)
	Player.euphoria.add_meter(euphoria_on_death)
	queue_free()
