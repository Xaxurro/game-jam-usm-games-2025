class_name WeaponResource
extends Resource

@export var name: StringName = "Unnamed Weapon"

@export_group("shoot")
@export var is_enemy: bool = true
@export var damage: int = 10
@export var firerate_in_seconds: float = 0.5
@export_subgroup("recoil")
@export var should_do_recoil: bool = true
@export var max_recoil_offset: float = 15.0
@export_group("decorative effects")
@export var shoot_sound_effect: AudioStream
@export var spritesheet: Texture2D
