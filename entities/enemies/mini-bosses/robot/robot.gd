class_name RobotEntity
extends CharacterBody2D

@export var is_active: bool = false
@export var speed_normal: float = 10
@export var speed_rushing: float = 20
@export var player: Player

enum ATTACK {
	NONE,
	RUSH,
	SHOOT
}

var current_attack: ATTACK = ATTACK.NONE
var target_position: Vector2

# func _init() -> void:
# 	player = get_tree().get_first_node_in_group("player")
# 	if player == null:
# 		push_warning("ROBOT MiniBoss could not find player!")

func _set_target_position() -> void:
	target_position = player.position

	var new_attack: int = randi() % 2
	if new_attack == 0:
		current_attack = ATTACK.RUSH
	if new_attack == 1:
		current_attack = ATTACK.SHOOT

func _attack_rush(_delta: float) -> void:
	var direction_to_player = (player.global_position - global_position).normalized()
	direction_to_player = direction_to_player * speed_rushing
	move_and_slide()

	const THRESHOLD_IN_PIXELS: int = 10
	if global_position.distance_to(player.global_position) < THRESHOLD_IN_PIXELS:
		current_attack = ATTACK.NONE
		velocity = Vector2.ZERO

func _attack_shoot(_delta: float) -> void:
	current_attack = ATTACK.NONE
	return

func _process(delta: float) -> void:
	if not is_active: return
	match current_attack:
		ATTACK.NONE: 
			_set_target_position()		
		ATTACK.RUSH:
			_attack_rush(delta)
		ATTACK.SHOOT:
			_attack_shoot(delta)
	return
