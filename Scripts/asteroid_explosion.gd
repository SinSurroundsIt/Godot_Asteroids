extends Node2D

@onready var sfx_explode: GPUParticles2D = get_node("explode")
@onready var sfx_sparks: GPUParticles2D = get_node("sparks")


func _ready():
	pass

func _on_gpu_particles_2d_finished():
	queue_free()
