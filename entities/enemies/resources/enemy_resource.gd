extends Resource
class_name EnemyResource

@export var health_current: float = 30
@export var detection_range: float = 300
@export var stop_distance: float = 40
@export var speed: float = 100
@export var acceleration: float = 400
@export var shoot_distance: float = 250
@export var shoot_cooldown: float = 1.5
@export var money_on_death: int = 100
@export var euphoria_on_death: int = 5
@export var knockback_strength: float = 200
@export var knockback_decay: float = 20
@export var weapon_type: Weapon.TYPE
