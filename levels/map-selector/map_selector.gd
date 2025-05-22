extends Control

var selected_level:String = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/menu/main_menu.tscn")


func _on_washington_pressed() -> void:
	selected_level = "res://levels/white-house/stage-1/stage1.tscn"


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(selected_level)
