class_name Player
extends CharacterBody2D

@export var health_max: int = 100
@export var health_current: int = 100
@export var movement_speed: int = 10
@export var money: int = 0

@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var primary_weapon: Weapon = $PrimaryWeapon
@onready var secondary_weapon: Weapon = $SecondaryWeapon
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hud: CanvasLayer = $Hud

var consumable_inventory: Array[Consumable] = []
var consumable_selected_index: int = 0


signal health_changed
signal consumable_selected_changed


func _ready() -> void:
	secondary_weapon.visible = false
	hud.visible = true

func _set_weapons_rotation(new_rotation: float) -> void:
	primary_weapon.get_node("Sprite").rotation = new_rotation
	secondary_weapon.get_node("Sprite").rotation = new_rotation

func _set_weapons_scale_y(new_scale: float) -> void:
	primary_weapon.get_node("Sprite").scale.y = new_scale
	secondary_weapon.get_node("Sprite").scale.y = new_scale

func _move(delta: float) -> void:
	var new_direction: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		new_direction.y = movement_speed * delta * -1
	if Input.is_action_pressed("move_down"):
		new_direction.y = movement_speed * delta
	if Input.is_action_pressed("move_left"):
		new_direction.x = movement_speed * delta * -1
	if Input.is_action_pressed("move_right"):
		new_direction.x = movement_speed * delta
	
	if new_direction == Vector2.ZERO:
		animation_player.play("idle")
	else:
		animation_player.play("running")
	
	
	position += new_direction
	
	##Handle Collition
	move_and_slide()

func _cycle_consumables() -> void:
	if Input.is_action_just_pressed("consumable_cycle"):
		if consumable_inventory.size() == 0: return
		consumable_selected_index += 1
		consumable_selected_index %= consumable_inventory.size()
		consumable_selected_changed.emit()

func _process_input(delta: float) -> void:
	_move(delta)
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
		primary_weapon.visible = true
		secondary_weapon.visible = true
		primary_weapon.shoot_at(target_direction)
	if Input.is_action_pressed("shoot_secondary_weapon"):
		primary_weapon.visible = false
		secondary_weapon.visible = true
		secondary_weapon.shoot_at(target_direction)

func use_consumable() -> void:
	if not Input.is_action_just_pressed("consumable_use"): return
	if consumable_inventory.size() == 0: return
	var consumable: Consumable = consumable_inventory[consumable_selected_index]
	if consumable.count == 0: return
	consumable.effect(self)
	consumable.count -= 1
	consumable_selected_changed.emit()

func pay(price: int) -> bool:
	if price > money: return false
	money -= price
	return true

func add_consumable(consumable: Consumable) -> void:
	if not consumable_inventory.has(consumable):
		consumable_inventory.append(consumable)
	consumable_selected_index = consumable_inventory.size() - 1 #Select the newest consumable
	consumable.count += 1
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

func _process(delta: float) -> void:
	_process_input(delta)
	var target_direction: Vector2 = _aim()
	_shoot_at(target_direction)
