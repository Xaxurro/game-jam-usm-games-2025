class_name Beer
extends ConsumableResource

@export var health_amount: int = 25

func effect() -> void:
	Player.change_health(health_amount)
