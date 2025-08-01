class_name ConsumableEntity
extends Area2D

@export var consumable_data: ConsumableResource = preload("res://entities/consumables/resources/beer.tres")
@export var count: int = 1
@export var price: int = 0

@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label

func _ready() -> void:
	if not consumable_data:
		printerr("ConsumableData NOT ASSIGNED FOR ConsumableEntity")
		queue_free()

	sprite.texture = consumable_data.texture

	if price > 0:
		label.text = "$%d" % price

func _on_body_entered(body: Node2D) -> void:
	if body != Player:
		return

	if price == 0 or Player.inventory.pay_money(price):
		Player.inventory.add_consumable(consumable_data, count)
		queue_free()
