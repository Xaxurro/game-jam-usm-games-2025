class_name Beer
extends Consumable

@export var health_amount: int = 25

func effect(player: Player) -> void:

	print("health_before: " % player.health_current)
	player.heal(health_amount)
	print("health_after: " % player.health_current)
