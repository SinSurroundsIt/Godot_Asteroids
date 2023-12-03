extends RigidBody2D
class_name Asteroid

@onready var project_resolution:Vector2 = get_viewport().content_scale_size
@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var collider: CollisionShape2D = get_node("CollisionShape2D")
@onready var random_mass: float 

@export var large_collider_rad: float = 48.0
@export var med_collider_rad: float = 100
@export var small_collider_rad: float = 8.0


var _b_is_phys_init: bool = false
var random_velocity: Vector2
var _hit_cap: int
var size: int = 3
var texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.set_texture(texture)
	_hit_cap = size
	if size == 3:
		random_mass = randf_range(500, 750)
		collider.shape.radius = large_collider_rad
	elif size == 2:
		random_mass = randf_range(250, 500)
		collider.shape.radius = med_collider_rad
	else:
		random_mass = randf_range(50, 250)
		collider.shape.radius = small_collider_rad
	mass = random_mass
	add_to_group("asteroids")

func _physics_process(_delta):
	if _b_is_phys_init == false:
		apply_central_impulse(random_velocity)
		apply_torque(50000)
		_b_is_phys_init = true
	pass


func _integrate_forces(state):
	state.transform = _Screen_Wrap(state.transform)

func _Screen_Wrap(transform) -> Transform2D:
	var xform = transform
	xform.origin.x = wrapf(position.x, -100.0, project_resolution.x + 100.0)
	xform.origin.y = wrapf(position.y, -100.0, project_resolution.y + 100.0)
	return xform
	
func take_weapon_damage():
	if _hit_cap > 0:
		_hit_cap -= 1;
	else:
		Events.asteroid_destroyed.emit(size, position, linear_velocity)
		Events.asteroid_destroyed_sound.emit()
		queue_free()
		
func destroy():
	Events.asteroid_destroyed.emit(size, position, linear_velocity)
	Events.asteroid_destroyed_sound.emit()
	queue_free()
		
func apply_whack(impulse: Vector2):
	apply_central_impulse(impulse)
	
func apply_spin(impulse: float):
	apply_torque_impulse(impulse)
