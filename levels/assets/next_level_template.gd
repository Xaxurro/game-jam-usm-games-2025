extends Area2D
var full_path = ""
var stages = ["stage-2/stage2.tscn","stage-3/stage3.tscn","stage-4/stage4.tscn"] ##No esta el primero porque la misison inicia en ese
var index = 0
var base_path = "" 
var entered = false

func extract_path(full_path: String) -> String:
	var trimmed_path = full_path.trim_prefix("res://")
	
	# Split into directories
	var directories = trimmed_path.split("/")
	
	if directories.size() >= 2:
		return "res://" + directories[0] + "/" + directories[1] + "/"
	return "res://" 

func _ready() -> void:
	full_path = get_tree().current_scene.scene_file_path


func _process(_delta: float) -> void:
	if entered == true and Input.is_action_just_pressed("interaction"):
		base_path = extract_path(full_path) + stages[index]
		get_tree().change_scene_to_file(base_path)

func _on_body_entered(_body: PhysicsBody2D) -> void:
	entered = true

func _on_body_exited(_body: PhysicsBody2D) -> void:
	entered = false
