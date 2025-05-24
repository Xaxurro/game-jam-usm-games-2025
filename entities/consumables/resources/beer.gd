class_name Beer
extends Consumable

@export var health_amount: int = 25

func effect(player: Player) -> void:
	player.heal(health_amount)
