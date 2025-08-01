class_name Level
extends Node2D

enum LEVEL_1 {
	WALMART,
	FRONTYARD,
	ENTRANCE,
	MIDDLE,
	BUNKER,
}

@onready var player_spawn: Marker2D = $PlayerSpawn

func _ready():
	Player.global_position = player_spawn.global_position
	Player.enable()
