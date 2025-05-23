extends Node

@export var player: Player

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var consumable_selected: TextureRect = $ConsumableSelected

func _update_health_bar() -> void:
	health_bar.value = player.health_current * 100 / player.health_max

func _update_consumable_selected() -> void:
	var consumable: Consumable = player.consumable_inventory[player.consumable_selected_index]
	var label: Label = consumable_selected.get_node("Label")
	consumable_selected.texture = consumable.texture
	label.text = consumable.name

func _ready() -> void:
	player.health_changed.connect(_update_health_bar)
	_update_health_bar()
	player.consumable_selected_changed.connect(_update_consumable_selected)
	_update_health_bar()
