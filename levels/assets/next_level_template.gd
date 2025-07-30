extends Area2D

@onready var next_level_text_label = $Label

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
var level_clear: bool = false


func extract_path(next_path: String) -> String:
	var trimmed_path = next_path.trim_prefix("res://")
	var directories = trimmed_path.split("/")
	if directories.size() >= 2:
		return "res://" + directories[0] + "/" + directories[1] + "/"
	return "res://" 

func _ready() -> void:
		
	##UI element
	next_level_text_label.visible = entered
	##Pathin for next level
	next_path = Global.full_path
	check = get_tree().current_scene.scene_file_path
	if check != "res://levels/walmart/walmart.tscn":
		Global.full_path = get_tree().current_scene.scene_file_path
		next_path = Global.full_path
			
func _process(_delta: float) -> void:
	
	##Next level Logic
	if entered and level_clear and Input.is_action_just_pressed("interaction")	:
		##Vamos recoriendo la lista con un index global para que no se pierdan entre stages
		if Global.stage_index < stages.size():
			var next_scene_path_in_array: String = stages[Global.stage_index]
			var scene_to_load: String = ""
			##Chek para ver si puede entrar al wallmart (tienda)
			if next_scene_path_in_array == "res://levels/walmart/walmart.tscn":
				scene_to_load = next_scene_path_in_array
			else:
				var current_stage_base_path = extract_path(next_path)
				scene_to_load = current_stage_base_path + next_scene_path_in_array

			Global.stage_index += 1 
			
			get_tree().change_scene_to_file(scene_to_load)

##Simplea ass code aHH
func _check_enemies() -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	##print(enemies.size())
	if enemies.size() == 0:
		level_clear = true
		

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("player"):
		entered = true
		_check_enemies()
		_next_level_text()
		

func _on_body_exited(body: PhysicsBody2D) -> void:
	if body.is_in_group("player"):
		entered = false
		_next_level_text()

func _next_level_text() -> void:
	next_level_text_label.visible = entered
	
