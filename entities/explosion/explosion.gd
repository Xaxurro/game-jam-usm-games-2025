class_name Explosion
extends Area2D

@onready var collision: CollisionShape2D = $Collision
@onready var lifetime: Timer = $Lifetime

var damage: float = 50
var affected_nodes: Array[Node2D] = []

func _ready():
	lifetime.timeout.connect(queue_free)

func _on_body_entered(body:Node2D) -> void:
	if not (body is Player or body.is_in_group("enemies")): return
	if affected_nodes.has(body): return
	if body is Player:
		Player.change_health(-damage)
		return
	body.call("recieve_damage", damage, global_position - body.global_position)
