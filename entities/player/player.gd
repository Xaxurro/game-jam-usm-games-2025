class_name Player
extends CharacterBody2D

@export var health_max: int = 100
@export var health_current: int = 100
@export var movement_speed: int = 200

@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var weapon_primary: Weapon = $PrimaryWeapon
@onready var weapon_secondary: Weapon = $SecondaryWeapon
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hud: CanvasLayer = $Hud

@export var inventory: Inventory = Inventory.new()

signal health_changed
signal consumable_selected_changed
signal money_changed

func _ready() -> void:
	weapon_secondary.visible = false
	hud.visible = true

func _set_weapons_rotation(new_rotation: float) -> void:
	weapon_primary.get_node("Sprite").rotation = new_rotation
	weapon_secondary.get_node("Sprite").rotation = new_rotation

func _set_weapons_scale_y(new_scale: float) -> void:
	weapon_primary.get_node("Sprite").scale.y = new_scale
	weapon_secondary.get_node("Sprite").scale.y = new_scale

func _update_velocity(delta: float) -> void:
	var input_direction: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		input_direction.y = movement_speed * delta * -1
	if Input.is_action_pressed("move_down"):
		input_direction.y = movement_speed * delta
	if Input.is_action_pressed("move_left"):
		input_direction.x = movement_speed * delta * -1
	if Input.is_action_pressed("move_right"):
		input_direction.x = movement_speed * delta
	
	velocity = input_direction.normalized() * movement_speed
	
	if input_direction == Vector2.ZERO:
		animation_player.play("idle")
	else:
		animation_player.play("running")
	
	var speed_should_reduce: bool = false
	if weapon_primary._cooldown.time_left != 0: speed_should_reduce = true
	if weapon_secondary._cooldown.time_left != 0: speed_should_reduce = true

	const SPEED_DIVIDER: int = 2
	if speed_should_reduce: velocity /= SPEED_DIVIDER
	
	##Handle Collition
	move_and_slide()

func _cycle_consumables() -> void:
	if Input.is_action_just_pressed("consumable_cycle"):
		inventory.cycle_consumables()
		consumable_selected_changed.emit()

func _process_input(delta: float) -> void:
	_update_velocity(delta)
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
	inventory.use_consumable(self)
	consumable_selected_changed.emit()

func pay(price: int) -> bool:
	var success: bool = inventory.pay_money(price)
	money_changed.emit()
	return success

func add_consumable(consumable: Consumable) -> void:
	inventory.add_consumable(consumable)
	consumable_selected_changed.emit()

func heal(health_recovered: int) -> bool:
	if health_current == health_max: return false
	self.health_current += health_recovered
	self.health_current %= health_max + 1 #Caps the health to the max
	health_changed.emit()
	return true

func recieve_damage(damage_recieved: int) -> bool:
	self.health_current -= damage_recieved
	if health_current <= 0:
		health_current = 0
	health_changed.emit()

	return health_current <= 0

func _physics_process(delta: float) -> void:
	_process_input(delta)
	var target_direction: Vector2 = _aim()
	_shoot_at(target_direction)
