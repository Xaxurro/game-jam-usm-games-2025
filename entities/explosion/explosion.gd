class_name Explosion
extends Area2D

@onready var collision: CollisionShape2D = $Collision
@onready var lifetime: Timer = $Lifetime

var damage: float = 50
var affected_nodes: Array[Node2D] = []

func _deal_damage() -> void:
	for node: Node2D in affected_nodes:
		if node is Player:
			Player.change_health(-damage)
			continue
		node.call("recieve_damage", damage, global_position - node.global_position)

func _ready():
	lifetime.timeout.connect(_deal_damage)

func _on_body_entered(body:Node2D) -> void:
	if not body is Player: return
	if not body.is_in_group("enemies"): return
	affected_nodes.append(body)
