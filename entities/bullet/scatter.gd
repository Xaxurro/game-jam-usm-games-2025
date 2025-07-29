class_name BulletScatter
extends Bullet

enum TYPE {
	NORMAL,
	EXPLOSIVE,
	BULKY,
	QUICK,
	SCATTER
}

enum TARGETS {
	PLAYER,
	ENEMY
}

@export var speed: float = 1000
@export var damage: float = 10
@export var lifespan_seconds: float = 5.0
@export var target: TARGETS = TARGETS.ENEMY

@onready var timer: Timer = $Timer
var initial_direction: Vector2

func _ready() -> void:
	linear_velocity = initial_direction * speed
	timer.wait_time = lifespan_seconds
	timer.timeout.connect(queue_free)
	if target == TARGETS.ENEMY:
		set_collision_mask_value(1, false)
	if target == TARGETS.PLAYER:
		set_collision_mask_value(2, false)
	timer.start()

func _on_body_entered(body: Node2D) -> void:
	if target == TARGETS.PLAYER and body is Player and Player.can_recieve_damage:
		Player.change_health(-damage)
		queue_free()
	if target == TARGETS.ENEMY and body.is_in_group("enemies"):
		var hit_direction = (body.global_position - global_position).normalized()
		body.call("recieve_damage", damage, hit_direction)
		queue_free()
	if body.is_in_group("walls"):
		queue_free()
	pass
