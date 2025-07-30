extends Node2D

@export var enemy_data: EnemyResource
@export var spawn_interval: float = 3.0
@export var max_enemies: int = 5
@export var auto_start: bool = true

@onready var spawn_timer: Timer = $SpawnTimer
@onready var enemy_template: CharacterBody2D = $Enemy

var enemies_spawned: int = 0
var enemy

func _ready():
	enemy = enemy_template.duplicate()
	enemy_template.queue_free()
	
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(spawn_enemy)
	
	spawn_timer.start()

func spawn_enemy():
	if enemies_spawned >= max_enemies:
		spawn_timer.stop()
	
	var enemy_instance = enemy.duplicate()
	enemy_instance.resource = enemy_data
	
	enemy_instance.position = global_position
	enemy_instance.visible = true  
	
	get_tree().current_scene.add_child(enemy_instance)
	enemies_spawned += 1
