extends CanvasLayer


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/map-selector/map-selector.tscn")


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
