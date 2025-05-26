extends Node2D

@onready var enemies: Node2D = $Enemies
@onready var robot: RobotEntity = $MiniBoss

func _process(_delta: float) -> void:
	if enemies.get_children().size() == 0:
		robot.is_active = true
