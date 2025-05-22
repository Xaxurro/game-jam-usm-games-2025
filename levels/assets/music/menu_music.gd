extends AudioStreamPlayer

const background_music = preload("res://levels/assets/music/menu-background-music.mp3")

func _play_music(music: AudioStream, volume: float = 0.0):
	if stream == music:
		return
	stream = music
	volume_db = volume
	play()
	
func play_menu_music():
	_play_music(background_music)
