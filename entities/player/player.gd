extends CharacterBody2D

@export var health_max: float = 100
@export var health_current: float = 100
@export var movement_speed: int = 250

@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var weapon_primary: Weapon = $WeaponPrimary
@onready var weapon_secondary: Weapon = $WeaponSecondary
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hud: CanvasLayer = $Hud
@onready var euphoria: Euphoria = $Euphoria
@onready var dodge: Dodge = $Dodge

@export var inventory: Inventory = Inventory.new()

var enabled: bool = true
var can_recieve_damage: bool = true

signal health_changed
signal consumable_selected_changed

func disable() -> void:
	enabled = false
	visible = false
	can_recieve_damage = false
	weapon_primary.visible = false
	weapon_secondary.visible = false
	hud.visible = false

func enable() -> void:
	enabled = true
	visible = true
	can_recieve_damage = true
	weapon_primary.visible = true
	weapon_secondary.visible = false
	hud.visible = true

func _ready() -> void:
	weapon_primary.weapon_resource.is_enemy = false
	weapon_secondary.weapon_resource.is_enemy = false
	disable()

func _set_weapons_rotation(new_rotation: float) -> void:
	weapon_primary.get_node("Sprite").rotation = new_rotation
	weapon_secondary.get_node("Sprite").rotation = new_rotation

func _set_weapons_scale_y(new_scale: float) -> void:
	weapon_primary.get_node("Sprite").scale.y = new_scale
	weapon_secondary.get_node("Sprite").scale.y = new_scale

func _update_velocity() -> void:
	var input_direction: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		input_direction.y += -1
	if Input.is_action_pressed("move_down"):
		input_direction.y += 1
	if Input.is_action_pressed("move_left"):
		input_direction.x += -1
	if Input.is_action_pressed("move_right"):
		input_direction.x += 1
	
	velocity = input_direction.normalized() * movement_speed
	if euphoria.is_active:
		velocity *= euphoria.movement_speed_multiplier
	
	if input_direction == Vector2.ZERO:
		animation_player.play("idle")
	else:
		animation_player.play("running")
	
	var speed_should_reduce: bool = false
	if weapon_primary.cooldown.time_left != 0: speed_should_reduce = true
	if weapon_secondary.cooldown.time_left != 0: speed_should_reduce = true

	const SPEED_DIVIDER: int = 2
	if speed_should_reduce: velocity /= SPEED_DIVIDER

func _cycle_consumables() -> void:
	if not Input.is_action_just_pressed("consumable_cycle"): return
	inventory.cycle_consumables()
	consumable_selected_changed.emit()

func use_consumable() -> void:
	if not Input.is_action_just_pressed("consumable_use"): return
	inventory.use_consumable()
	consumable_selected_changed.emit()

func toggle_euphoria() -> void:
	if not Input.is_action_just_pressed("euphoria_toggle"): return
	if euphoria.is_active:
		euphoria.deactivate()
	else:
		euphoria.activate()

func do_dodge() -> void:
	if not Input.is_action_just_pressed("dodge"): return
	if not dodge.cooldown.is_stopped(): return
	dodge.use()
	var direction = (get_global_mouse_position() - global_position).normalized()
	velocity = direction * movement_speed * 50

func _process_input(_delta: float) -> void:
	_update_velocity()
	_cycle_consumables()
	use_consumable()
	toggle_euphoria()
	do_dodge()
	move_and_slide()

## Gets the mouse position and changes the rotation of the character + the weapon to point at the mouse
func _aim() -> Vector2:
	# Rotate the weapon
	var mouse_position: Vector2 = get_global_mouse_position()
	var direction: Vector2 = mouse_position - global_position
	var angle_rad: float = atan2(direction.y, direction.x)
	_set_weapons_rotation(angle_rad)

	const THRESHOLD: float = 0.1
	# Aim left
	if direction.x < -THRESHOLD:
		character_sprite.scale.x = -1
		_set_weapons_scale_y(-1)	# Without this the weapon looks inverted
	# Aim right
	else:
		character_sprite.scale.x = 1
		_set_weapons_scale_y(1)

	return direction.normalized()

## Shoots the weapon at the desired direction, swapping the weapon to the one shooting
func _shoot_at(target_direction:Vector2) -> void:
	# Both cooldowns must be done to shoot again
	if not weapon_primary.cooldown.is_stopped() or not weapon_secondary.cooldown.is_stopped(): return
	# return to prevent shooting twice
	if Input.is_action_pressed("shoot_primary_weapon"):
		weapon_primary.visible = true
		weapon_secondary.visible = false
		weapon_primary.shoot_at(target_direction)
		return
	if Input.is_action_pressed("shoot_secondary_weapon"):
		weapon_primary.visible = false
		weapon_secondary.visible = true
		weapon_secondary.shoot_at(target_direction)

func change_health(amount: float) -> void:
	if amount > 0 and health_current == health_max: return
	if amount < 0 and health_current == 0: return
	health_current = clampf(health_current + amount, 0, health_max)
	health_changed.emit()
	if health_current == 0:
		kill()

func _physics_process(delta: float) -> void:
	if not enabled: return
	_process_input(delta)
	var target_direction: Vector2 = _aim()
	_shoot_at(target_direction)
	if euphoria.is_active:
		change_health(euphoria.regeneration_rate_in_seconds * delta)

func kill() -> void:
	Global.stage_index = 0
	get_tree().change_scene_to_file("res://levels/menu/main_menu.tscn")
