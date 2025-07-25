class_name Euphoria
extends Node

## Visual Effect Canvas Layer
@onready var red_filter: CanvasLayer = $RedFilter

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
## Player's damage multiplier
var movement_speed_multiplier: float = 2.0
## Player's added health when getting damaged
var regeneration_rate_in_seconds: float = 5.0

func activate() -> void:
	red_filter.visible = true
	is_active = true

func deactivate() -> void:
	red_filter.visible = false
	is_active = false

func reduce_meter(amount: float):
	meter_current -= amount
	if meter_current <= 0:
		meter_current = 0
		deactivate()

func _process(delta):
	reduce_meter(meter_decay_per_second * delta)
