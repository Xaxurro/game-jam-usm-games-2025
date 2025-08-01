extends Area2D

@onready var next_level_text_label = $Label

var current_stage: Level.LEVEL_1 
var stages: Array[Level.LEVEL_1] = [
	Level.LEVEL_1.FRONTYARD, 
	Level.LEVEL_1.WALMART, 
	Level.LEVEL_1.ENTRANCE, 
	Level.LEVEL_1.MIDDLE, 
	Level.LEVEL_1.WALMART, 
	Level.LEVEL_1.BUNKER, 
]

var player_entered: bool = false
var level_clear: bool = false
var next_stage: int = 0 

func _ready() -> void:
	##UI element
	next_level_text_label.visible = false
	##Pathin for next level
	next_stage = (Global.stage_index + 1) % stages.size()

	## Codigo para volver al menu xddddd
	if next_stage == 0:
		print_rich("levels/assets/next_level_template.gd: [color=#e01b24]ESTO DEBERIA VERSE CUANDO SE PASA EL STAGE 4, PROGRAMA LA VUELTA AL MENU[/color]")
			
func _process(_delta: float) -> void:
	if not level_clear: return
	if not player_entered: return
	if not Input.is_action_just_pressed("interaction"): return
	
	##Next level Logic
	var next_scene: String = Constants.SCENES_PATHS.level_1[stages[next_stage]]
	print(next_scene)

	Global.stage_index += 1 
	
	get_tree().change_scene_to_file(next_scene)

##Simplea ass code aHH
func _check_enemies() -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() == 0:
		level_clear = true
		

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body != Player: return
	player_entered = true
	next_level_text_label.visible = true
	_check_enemies()
		

func _on_body_exited(body: PhysicsBody2D) -> void:
	if body != Player: return
	player_entered = false
	next_level_text_label.visible = false
	
