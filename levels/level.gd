class_name Level
extends Node2D

@onready var player_spawn: Marker2D = $PlayerSpawn

func _ready():
	Player.global_position = player_spawn.global_position
