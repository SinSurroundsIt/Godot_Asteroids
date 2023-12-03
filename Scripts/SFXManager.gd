extends Node

@onready var asteroid_explosion_tscn = preload("res://Scenes/asteroid_explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.asteroid_explode.connect(_Asteroid_Explosion)
	Events.ship_explode.connect(_Ship_Explosion)


func _Asteroid_Explosion(pos: Vector2, _vel: Vector2):
	var explosion = asteroid_explosion_tscn.instantiate()
	add_child(explosion)
	explosion.position = pos

func _Ship_Explosion(pos: Vector2):
	var displacement_vector: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * randf_range(8, 16)
	var new_pos: Vector2 = pos + displacement_vector
	var explosion = asteroid_explosion_tscn.instantiate()
	add_child(explosion)
	explosion.position = new_pos
