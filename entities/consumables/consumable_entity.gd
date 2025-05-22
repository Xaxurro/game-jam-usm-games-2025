class_name ConsumableEntity
extends Area2D

@export var consumable_type: Consumable = preload("res://entities/consumables/resources/beer.tres")
@export var is_free: bool = true

@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label

func _ready() -> void:
	sprite.texture = consumable_type.texture
	var new_shape: RectangleShape2D = RectangleShape2D.new()
	new_shape.size = sprite.texture.get_size()
	collision_shape.shape = new_shape

	if not is_free:
		label.text = "$%d" % consumable_type.price

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if is_free or body.call("pay", consumable_type.price):
			body.call("add_consumable", consumable_type)
			queue_free()
	pass
