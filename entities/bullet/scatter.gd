class_name BulletScatter
extends Bullet

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
