class_name BulletExplosive
extends Bullet

const EXPLOSION_SCENE: PackedScene = preload("uid://sy8t720vk3tn")

func _explode() -> void:
	visible = false
	var explosion: Explosion = EXPLOSION_SCENE.instantiate()
	explosion.global_position = global_position
	add_sibling(explosion)
	queue_free()

func _ready() -> void:
	linear_velocity = initial_direction * speed
	timer.wait_time = lifespan_seconds
	timer.timeout.connect(_explode)
	if target == TARGETS.ENEMY:
		set_collision_mask_value(1, false)
	if target == TARGETS.PLAYER:
		set_collision_mask_value(2, false)
	timer.start()


func _on_body_entered(body: Node2D) -> void:
	if target == TARGETS.PLAYER and body is Player and Player.can_recieve_damage: _explode()
	if target == TARGETS.ENEMY and body.is_in_group("enemies"): _explode()
	if body.is_in_group("walls"): _explode()
