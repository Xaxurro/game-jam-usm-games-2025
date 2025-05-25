extends Node2D

@onready var background_music: AudioStreamPlayer2D = $BackgroundMusic 

func _ready() -> void:
	if background_music:
		background_music.play()
	else:
		push_warning("BackgroundMusic node not found! Make sure it's named 'BackgroundMusic' and is a child of this node.")

func _process(delta: float) -> void:
	pass
