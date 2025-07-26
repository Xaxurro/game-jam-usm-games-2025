class_name Euphoria
extends Node

## Visual Effect Canvas Layer
@onready var red_filter: CanvasLayer = $RedFilter
## BGM
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var bgm: AudioStream = preload("res://entities/player/assets/euphoria-take-2.wav")

## Current Euphoria meter amount
var meter_current: float = 0
## Required Euphoria meter amount to activate
var meter_required: float = 100
## Max Euphoria meter amount
var meter_max: float = 100
## The rate the meter starts to decay (in seconds) when it's active
var meter_decay_per_second: float = 5
## If is true the meter_current starts to decay
var is_active: bool = false

## Player's damage multiplier
var damage_multiplier: float = 1.5
## Player's shoot speed multiplier
var shoot_speed_multiplier: float = 1.5
## Player's damage multiplier
var movement_speed_multiplier: float = 2.0
## Player's added health when getting damaged
var regeneration_rate_in_seconds: float = 5.0

## Activates Euphoria if `meter_current` is enough to activate 
func activate() -> void:
	if meter_current < meter_required: return
	red_filter.visible = true
	is_active = true
	audio_player.stream = bgm
	audio_player.volume_db = -10
	audio_player.play()

## Deactivates Euphoria and consumes meter if it was manually deactivated
func deactivate() -> void:
	red_filter.visible = false
	is_active = false
	add_meter(-25)

func add_meter(amount: float) -> void:
	meter_current = clampf(meter_current + amount, 0, meter_max)
	if meter_current == 0:
		deactivate()

func _process(delta) -> void:
	if is_active:
		add_meter(-meter_decay_per_second * delta)
