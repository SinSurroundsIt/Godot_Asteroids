extends Node

@onready var menu_music: AudioStream = preload("res://Music/unstable_field.ogg")
@onready var music_stream: AudioStreamPlayer = AudioStreamPlayer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(music_stream)
	music_stream.stream = menu_music
	music_stream.volume_db = GameSettings.music_volume
	music_stream.play()
	
	GameSettings.music_volume_changed.connect(_On_Music_Volume_Changed)

func _On_Music_Volume_Changed(new_volume: float) -> void:
	music_stream.volume_db = new_volume
