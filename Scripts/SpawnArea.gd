extends Area2D

var _b_repulse: bool = false
@onready var _radius: float = ($CollisionShape2D.shape as CircleShape2D).radius

# Called when the node enters the scene tree for the first time.
func _ready():
	# Disable monitoring entirely; we will repulse via manual distance checks to avoid Box2D area exit issues.
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)
	set_physics_process(false)
	Events.set_spawn_safety.connect(_Set_Repulse)


func _physics_process(_delta):
	if _b_repulse:
		_Repulse_Bodies()


func _Repulse_Bodies() -> void:
	var asteroids: Array = get_tree().get_nodes_in_group("asteroids")
	for asteroid: Asteroid in asteroids:
		var to_body: Vector2 = asteroid.position - position
		if to_body.length_squared() <= _radius * _radius:
			var direction = to_body.normalized()
			asteroid.apply_central_force(direction * GameSettings.repulse_strength * asteroid.mass)

func _Set_Repulse(repulse: bool):
	_b_repulse = repulse
	set_physics_process(repulse)
