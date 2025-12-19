extends Node

const SETTINGS_FILE_PATH := "user://settings.save"

signal music_volume_changed(new_volume: float)
signal sfx_volume_changed(new_volume: float)
signal ui_volume_changed(new_volume: float)

var _music_volume: float = -20.0
var _sfx_volume: float = -10.0
var _ui_volume: float = -10.0

@export var music_volume: float = -20:
	set(value):
		_music_volume = value
		music_volume_changed.emit(value)
		_Save_Settings()
	get:
		return _music_volume

@export var sfx_volume: float = -10:
	set(value):
		_sfx_volume = value
		sfx_volume_changed.emit(value)
		_Save_Settings()
	get:
		return _sfx_volume

@export var ui_volume: float = -10:
	set(value):
		_ui_volume = value
		ui_volume_changed.emit(value)
		_Save_Settings()
	get:
		return _ui_volume

var repulse_strength: float = 75

var spawn_turbulence: float = 30

var initial_spawns: int = 1

var add_life_divisor: int = 100


func _ready() -> void:
	# Load persisted settings on startup so volumes survive restarts.
	_Load_Settings()
	# Emit signals to inform listeners of loaded values (e.g., AudioManager).
	music_volume_changed.emit(_music_volume)
	sfx_volume_changed.emit(_sfx_volume)
	ui_volume_changed.emit(_ui_volume)


func _Save_Settings() -> void:
	var file := FileAccess.open(SETTINGS_FILE_PATH, FileAccess.WRITE)
	if file:
		var data := {
			"music_volume": _music_volume,
			"sfx_volume": _sfx_volume,
			"ui_volume": _ui_volume,
		}
		file.store_line(JSON.stringify(data))
		file.close()


func _Load_Settings() -> void:
	if not FileAccess.file_exists(SETTINGS_FILE_PATH):
		return
	var file := FileAccess.open(SETTINGS_FILE_PATH, FileAccess.READ)
	if file:
		var json := JSON.new()
		var parse_result := json.parse(file.get_line())
		if parse_result == OK:
			var data: Dictionary = json.get_data()
			_music_volume = data.get("music_volume", _music_volume)
			_sfx_volume = data.get("sfx_volume", _sfx_volume)
			_ui_volume = data.get("ui_volume", _ui_volume)
		file.close()
