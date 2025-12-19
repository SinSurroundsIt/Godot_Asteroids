extends Node

signal music_volume_changed(new_volume: float)
signal sfx_volume_changed(new_volume: float)
signal ui_volume_changed(new_volume: float)

@export var music_volume: float = -20:
	set(value):
		music_volume = value
		music_volume_changed.emit(value)
		
@export var sfx_volume: float = -10:
	set(value):
		sfx_volume = value
		sfx_volume_changed.emit(value)

@export var ui_volume: float = -10:
	set(value):
		ui_volume = value
		ui_volume_changed.emit(value)

var repulse_strength: float = 75

var spawn_turbulence: float = 30

var initial_spawns: int = 1

var add_life_divisor: int = 100
