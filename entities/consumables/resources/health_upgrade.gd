class_name HealthUpgrade
extends ConsumableResource

@export var added_health: int = 10

func effect() -> void:
	if Player.health_max < 150:
		Player.health_max += added_health
	pass
