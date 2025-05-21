class_name EntityPlayer
extends CharacterBody2D

@export var movement_speed: int = 10


@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var primary_weapon: Weapon = $M60
@onready var secondary_weapon: Weapon = $Shotgun
@onready var _animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	secondary_weapon.visible = false

func _set_weapons_rotation(new_rotation: float) -> void:
	primary_weapon.get_node("Sprite").rotation = new_rotation
	secondary_weapon.get_node("Sprite").rotation = new_rotation

func _set_weapons_scale_y(new_scale: float) -> void:
	primary_weapon.get_node("Sprite").scale.y = new_scale
	secondary_weapon.get_node("Sprite").scale.y = new_scale

func _movement(delta: float) -> void:
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
		_animation_player.play("idle")
	else:
		_animation_player.play("running")
	
	
	position += new_direction
	
	##Handle Collition
	move_and_slide()

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

func _process(delta: float) -> void:
	_movement(delta)
	var target_direction: Vector2 = _aim()
	_shoot_at(target_direction)
