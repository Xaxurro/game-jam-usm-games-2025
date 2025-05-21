extends Area2D

var player_inside = false

func _process(delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("interaction"):
		get_tree().change_scene_to_file("res://levels/white-house/stage-2/stage2.tscn")

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("player"): 
		player_inside = true

func _on_body_exited(body: PhysicsBody2D) -> void:
	if body.is_in_group("player"):
		player_inside = false
