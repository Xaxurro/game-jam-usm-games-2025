extends Node2D

@export var enemy_scene: PackedScene 
@export var spawn_interval: float = 1.0
@export var total_enemies_to_spawn: int = 5 

var _spawned_count: int = 0
var _timer: Timer 

func _ready() -> void:
	if enemy_scene == null:
		printerr("Error: 'enemy_scene' is not assigned in the Spawner!")
		set_process(false) 
		return

	_timer = Timer.new()
	_timer.wait_time = spawn_interval
	_timer.autostart = true 
	_timer.one_shot = false 
	_timer.timeout.connect(_on_timer_timeout)

	add_child(_timer)

	print("Spawner ready! Will spawn %d enemies every %f seconds." % [total_enemies_to_spawn, spawn_interval])


func _on_timer_timeout() -> void:
	if _spawned_count >= total_enemies_to_spawn:
		_timer.stop() 
		print("Spawner finished: All %d enemies spawned." % total_enemies_to_spawn)
		return

	spawn_enemy()
	_spawned_count += 1


func spawn_enemy() -> void:
	var new_enemy = enemy_scene.instantiate()
	new_enemy.global_position = global_position 

	get_parent().add_child(new_enemy)

	print("Spawned enemy #%d at %s" % [_spawned_count + 1, new_enemy.global_position])
