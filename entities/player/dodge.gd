class_name Dodge
extends Node

@onready var cooldown: Timer = $Cooldown
@onready var iframes: Timer = $IFrames

func _on_timeout() -> void:
	Player.can_recieve_damage  =true

func _ready():
	iframes.timeout.connect(_on_timeout)

func use() -> void:
	cooldown.start()
	iframes.start()
	Player.can_recieve_damage = false
