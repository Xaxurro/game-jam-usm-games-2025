class_name Consumable
extends Resource

@export var name: StringName
@export var count: int = 0
@export var price: int = 0
@export var texture: Texture2D

func effect(player: Player) -> void:
	print_rich("[color=red]EMPTY EFFECT[/color]")
	pass
