extends Area2D
var full_path = ""
var stages = ["stage-2/stage2.tscn", "stage-3/stage3.tscn", "stage-4/stage4.tscn"]
var base_path = "" 
var entered = false

func extract_path(full_path: String) -> String:
	var trimmed_path = full_path.trim_prefix("res://")
	var directories = trimmed_path.split("/")
	if directories.size() >= 2:
		return "res://" + directories[0] + "/" + directories[1] + "/"
	return "res://" 

func _ready() -> void:
	full_path = get_tree().current_scene.scene_file_path
	print(full_path)
	print(stages[Global.stage_index])
	

func _process(_delta: float) -> void:
	if entered and Input.is_action_just_pressed("interaction"):
		if Global.stage_index < stages.size():
			base_path = extract_path(full_path) + stages[Global.stage_index]
			Global.stage_index = Global.stage_index + 1
			get_tree().change_scene_to_file(base_path)


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("player"):
		entered = true

func _on_body_exited(body: PhysicsBody2D) -> void:
	if body.is_in_group("player"):
		entered = false
