class_name Level
extends Node2D

enum LEVEL_1 {
	WALMART,
	FRONTYARD,
	ENTRANCE,
	MIDDLE,
	BUNKER,
}

@export var track: AudioStream
@onready var player_spawn: Marker2D = $PlayerSpawn

func _ready():
	if not track: printerr("NO TRACK SELECTED FOR THIS STAGE")
	Constants.bgm.stop()
	Constants.bgm.stream = track
	Constants.bgm.play()
	Player.global_position = player_spawn.global_position
	Player.enable()
