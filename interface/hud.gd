extends Node

@export var player: Player

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var consumable_selected: TextureRect = $ConsumableSelected
@onready var money: Label = $Money

func _update_health_bar() -> void:
	health_bar.value = player.health_current * 100 / player.health_max

func _update_consumable_selected() -> void:
	var consumable: Consumable = player.inventory.selected_consumable
	var label: Label = consumable_selected.get_node("Label")
	if consumable == null:
		consumable_selected.texture = null
		label.text = ""
		return
	consumable_selected.texture = consumable.texture
	label.text = "%s x %d" % [consumable.name, consumable.count]

func _update_money() -> void:
	money.text = "$%d" % player.inventory.money

func _ready() -> void:
	player.health_changed.connect(_update_health_bar)
	_update_health_bar()

	player.consumable_selected_changed.connect(_update_consumable_selected)
	_update_health_bar()

	player.money_changed.connect(_update_money)
	_update_money()
