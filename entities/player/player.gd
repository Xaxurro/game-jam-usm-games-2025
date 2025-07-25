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

@export var inventory: Inventory = Inventory.new()

signal health_changed
signal consumable_selected_changed
signal money_changed

func _ready() -> void:
	## DEBUG
	euphoria.meter_current = 100
	euphoria.activate()
	## DEBUG
	weapon_primary.weapon_resource.is_enemy = false
	weapon_secondary.weapon_resource.is_enemy = false
	weapon_secondary.visible = false
	hud.visible = true

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
	if weapon_primary._cooldown.time_left != 0: speed_should_reduce = true
	if weapon_secondary._cooldown.time_left != 0: speed_should_reduce = true

	const SPEED_DIVIDER: int = 2
	if speed_should_reduce: velocity /= SPEED_DIVIDER
	
	move_and_slide()

func _cycle_consumables() -> void:
	if Input.is_action_just_pressed("consumable_cycle"):
		inventory.cycle_consumables()
		consumable_selected_changed.emit()

func _process_input(_delta: float) -> void:
	_update_velocity()
	_cycle_consumables()
	use_consumable()

# Gets the mouse position and changes the rotation of the character + the weapon to point at the mouse
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

func _shoot_at(target_direction:Vector2) -> void:
	# Execute code only when pressed right click and is not on cooldown
	if Input.is_action_pressed("shoot_primary_weapon"):
		weapon_primary.visible = true
		weapon_secondary.visible = false
		weapon_primary.shoot_at(target_direction)
	if Input.is_action_pressed("shoot_secondary_weapon"):
		weapon_primary.visible = false
		weapon_secondary.visible = true
		weapon_secondary.shoot_at(target_direction)

func use_consumable() -> void:
	if not Input.is_action_just_pressed("consumable_use"): return
	inventory.use_consumable()
	consumable_selected_changed.emit()

func add_money(amount: int) -> void:
	inventory.add_money(amount)
	money_changed.emit()

func pay(price: int) -> bool:
	var success: bool = inventory.pay_money(price)
	money_changed.emit()
	return success

func add_consumable(consumable: ConsumableResource) -> void:
	inventory.add_consumable(consumable)
	consumable_selected_changed.emit()

func change_health(amount: float) -> void:
	if amount > 0 and health_current == health_max: return
	if amount < 0 and health_current == 0: return
	health_current = clampf(health_current + amount, 0, health_max)
	health_changed.emit()
	if health_current == 0:
		kill()

func _physics_process(delta: float) -> void:
	_process_input(delta)
	var target_direction: Vector2 = _aim()
	_shoot_at(target_direction)
	if euphoria.is_active:
		change_health(euphoria.regeneration_rate_in_seconds * delta)

func kill() -> void:
	Global.stage_index = 0
	get_tree().change_scene_to_file("res://levels/menu/main_menu.tscn")
