class_name Grenade
extends ConsumableResource

@export var damage: int = 50
@export var lifetime: float = 5

const grenade_bullet_scene: PackedScene = preload("uid://cr0efyqty4m3q")

func effect() -> void:
	var grenade_instance: RigidBody2D = grenade_bullet_scene.instantiate()
	grenade_instance.global_position = Player.global_position
	Player.get_parent().add_child(grenade_instance)
