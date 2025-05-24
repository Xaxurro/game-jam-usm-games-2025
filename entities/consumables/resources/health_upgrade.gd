class_name HealthUpgrade
extends Consumable

@export var added_health: int = 10

func effect(player: Player) -> void:
	if player.health_max < 150:
		player.health_max += added_health
	pass
