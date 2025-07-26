class_name ConsumableEntity
extends Area2D

@export var consumable_data: ConsumableResource = preload("res://entities/consumables/resources/beer.tres")
@export var is_free: bool = true

@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label

func _ready() -> void:
	if not consumable_data:
		printerr("ConsumableData NOT ASSIGNED FOR ConsumableEntity")
		queue_free()

	sprite.texture = consumable_data.texture
	var new_shape: RectangleShape2D = RectangleShape2D.new()
	new_shape.size = sprite.texture.get_size()
	collision_shape.shape = new_shape

	if not is_free:
		label.text = "$%d" % consumable_data.price

func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		return

	if is_free or Player.inventory.pay(consumable_data.price):
		Player.add_consumable(consumable_data.duplicate())
		queue_free()
