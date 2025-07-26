extends Node

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var consumable_selected: TextureRect = $ConsumableSelected
@onready var money: Label = $Money

func _update_health_bar() -> void:
	health_bar.value = Player.health_current * 100 / Player.health_max

func _update_consumable_selected() -> void:
	var consumable: ConsumableResource = Player.inventory.selected_consumable
	var label: Label = consumable_selected.get_node("Label")
	if consumable == null:
		consumable_selected.texture = null
		label.text = ""
		return
	consumable_selected.texture = consumable.texture
	label.text = "%s x %d" % [consumable.name, consumable.count]

func _update_money() -> void:
	money.text = "$%d" % Player.inventory.money

func _ready() -> void:
	Player.health_changed.connect(_update_health_bar)
	_update_health_bar()

	Player.consumable_selected_changed.connect(_update_consumable_selected)
	_update_health_bar()

	Player.inventory.money_changed.connect(_update_money)
	_update_money()
