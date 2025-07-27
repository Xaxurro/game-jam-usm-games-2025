extends Node2D

const enemy_scene = preload("res://entities/enemies/enemy.tscn")

@export var enemy_data: EnemyResource
@export var spawn_interval: float = 3.0
@export var max_enemies: int = 5
@export var auto_start: bool = true

@onready var spawn_timer: Timer = $SpawnTimer
var enemies_spawned: int = 0

func _ready():
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(spawn_enemy)
	if auto_start:
		spawn_timer.start()

func spawn_enemy():
	if enemies_spawned >= max_enemies:
		spawn_timer.stop()
		return

	var enemy = enemy_scene.instantiate()
	enemy.data = enemy_data
	enemy.global_position = global_position
	enemy.spawner_ref = self 
	get_tree().current_scene.add_child(enemy)

	enemies_spawned += 1

func notify_enemy_died():
	enemies_spawned = max(0, enemies_spawned - 1)
	if spawn_timer.is_stopped():
		spawn_timer.start()
