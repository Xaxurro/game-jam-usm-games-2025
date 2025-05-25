extends Area2D
var next_path = ""
var check = ""
var stages: Array[String] = [
	"res://levels/walmart/walmart.tscn", 
	"stage-2/stage2.tscn",               
	"stage-3/stage3.tscn",              
	"res://levels/walmart/walmart.tscn",
	"stage-4/stage4.tscn"                
]

var entered: bool = false

func extract_path(next_path: String) -> String:
	var trimmed_path = next_path.trim_prefix("res://")
	var directories = trimmed_path.split("/")
	if directories.size() >= 2:
		return "res://" + directories[0] + "/" + directories[1] + "/"
	return "res://" 

func _ready() -> void:
	next_path = Global.full_path
	check = get_tree().current_scene.scene_file_path
	if check != "res://levels/walmart/walmart.tscn":
		Global.full_path = get_tree().current_scene.scene_file_path
		next_path = Global.full_path
			
func _process(_delta: float) -> void:
	if entered and Input.is_action_just_pressed("interaction"):
		if Global.stage_index < stages.size():
			var next_scene_path_in_array: String = stages[Global.stage_index]
			var scene_to_load: String = ""

			if next_scene_path_in_array == "res://levels/walmart/walmart.tscn":
				scene_to_load = next_scene_path_in_array
			else:
				var current_stage_base_path = extract_path(next_path)
				scene_to_load = current_stage_base_path + next_scene_path_in_array

			Global.stage_index += 1 
			
			get_tree().change_scene_to_file(scene_to_load)

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("player"):
		entered = true


func _on_body_exited(body: PhysicsBody2D) -> void:
	if body.is_in_group("player"):
		entered = false
