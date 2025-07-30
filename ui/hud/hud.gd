extends Node

@onready var health_bar: TextureProgressBar = $HContainer/BarsContainer/HealthBar
@onready var euphoria_bar: TextureProgressBar = $HContainer/BarsContainer/EuphoriaBar
@onready var money: Label = $HContainer/ResourcesContainer/Money
@onready var consumable_selected: TextureRect = $HContainer/ResourcesContainer/ConsumableContainer/Icon
@onready var consumable_selected_label: Label = $HContainer/ResourcesContainer/ConsumableContainer/Label

func _update_health_bar() -> void:
	health_bar.value = Player.health_current * 100 / Player.health_max

func _update_euphoria_bar() -> void:
	euphoria_bar.value = Player.euphoria.meter_current * 100 / Player.euphoria.meter_max

func _update_consumable_selected() -> void:
	var consumable: ConsumableResource = Player.inventory.selected_consumable
	if consumable == null:
		consumable_selected.texture = null
		consumable_selected_label.text = ""
		return
	consumable_selected.texture = consumable.texture
	consumable_selected_label.text = "%s x %d" % [consumable.name, consumable.count]

func _update_money() -> void:
	money.text = "Money: $%d" % Player.inventory.money

func _connect_signals() -> void:
	Player.health_changed.connect(_update_health_bar)
	_update_health_bar()

	Player.euphoria.euphoria_changed.connect(_update_euphoria_bar)
	_update_euphoria_bar()

	Player.inventory.consumables_changed.connect(_update_consumable_selected)
	_update_health_bar()

	Player.inventory.money_changed.connect(_update_money)
	_update_money()

func _ready() -> void:
	call_deferred("_connect_signals")
