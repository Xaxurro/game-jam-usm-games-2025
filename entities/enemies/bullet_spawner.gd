extends Node2D

const BulletScene = preload("uid://c3yoxd22ehu6h") 

@onready var rotater: Node2D = $Rotater
@onready var shoot_timer: Timer = $ShootTimer

@export var rotate_speed = 20.0 
@export var shooter_timer_wait_time = 0.05
@export var spawn_point_amount = 4
@export var radius = 20.0

func _ready() -> void:
	setup_spawn_points(spawn_point_amount)
	shoot_timer.wait_time = shooter_timer_wait_time

func _process(delta: float) -> void:
	rotater.rotation += deg_to_rad(rotate_speed * delta)

func _on_shoot_timer_timeout() -> void:
	for s in rotater.get_children():
		var bullet = BulletScene.instantiate()
		bullet.target = Bullet.TARGETS.PLAYER
		get_tree().root.add_child(bullet)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation
		bullet.linear_velocity = Vector2.RIGHT.rotated(s.global_rotation) * bullet.speed

func setup_spawn_points(amount: int) -> void:
	for child in rotater.get_children():
		child.queue_free()

	var step = 2 * PI / amount
	for i in range(amount):
		var spawn_point = Node2D.new()
		spawn_point.name = "SpawnPoint%d" % i
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)

func increase_spawn_points(new_amount: int) -> void:
	if new_amount > spawn_point_amount:
		spawn_point_amount = new_amount
		setup_spawn_points(new_amount)

func reverse_rotation() -> void:
	rotate_speed = -rotate_speed
