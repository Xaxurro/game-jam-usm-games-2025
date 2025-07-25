class_name Euphoria

## Current Euphoria meter amount
var meter_current: int = 0
## Required Euphoria meter amount to activate
var meter_required: int = 100
## Max Euphoria meter amount
var meter_max: int = 100
## The rate the meter starts to decay (in seconds) when it's active
var meter_decay_per_second: int = 5
## If is true the meter_current starts to decay
var is_active: bool = false

## Player's damage multiplier
var damage_multiplier: float = 1.5
## Player's damage multiplier
var movement_speed_multiplier: float = 2.0
## Player's added health when getting damaged
var regeneration_rate_in_seconds: float = 5.0
