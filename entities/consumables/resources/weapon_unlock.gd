class_name ConsumableResource
extends Resource

@export var name: StringName
@export var count: int = 0
@export var price: int = 0
@export var texture: Texture2D

func effect() -> void:
	print_rich("[color=red]EMPTY EFFECT[/color]")
	pass
