extends Control

@onready var warmup_container: Node2D = $WarmupContainer

var _shader_list: Array = [
	preload("res://Scripts/pause_menu_blur.gdshader")
]

var _particle_scenes: Array = [
	preload("res://Scenes/ship.tscn"),
	preload("res://Scenes/laser_impact.tscn"),
	preload("res://Scenes/asteroid_explosion.tscn")
]

func _ready() -> void:
	# Give the engine a moment to render the "Loading..." text
	await get_tree().process_frame
	await get_tree().process_frame
	
	_compile_shaders()
	_compile_particles()
	
	# Allow one frame for the GPU to process the new nodes
	await get_tree().process_frame
	
	# Cleanup instances safely
	for child in warmup_container.get_children():
		if child.has_method("disable_collisions"):
			child.disable_collisions()
			
	# Give physics a moment to process the disabling
	await get_tree().physics_frame

	for child in warmup_container.get_children():
		child.queue_free()
		
	# Wait one more frame for safety
	await get_tree().process_frame
	
	# Changing scene
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _compile_shaders() -> void:
	for shader in _shader_list:
		var rect = ColorRect.new()
		var mat = ShaderMaterial.new()
		mat.shader = shader
		rect.material = mat
		# Make it tiny and seemingly invisible strictly speaking, 
		# but it needs to be "drawn"
		rect.size = Vector2(2, 2) 
		rect.color = Color(1, 1, 1, 0.01) # Low alpha might still trigger shader
		warmup_container.add_child(rect)

func _compile_particles() -> void:
	var i = 0
	for scene in _particle_scenes:
		var instance = scene.instantiate()
		instance.position = Vector2(i * 2000, i * 2000)
		warmup_container.add_child(instance)
		_trigger_particles(instance)
		i += 1

func _trigger_particles(node: Node) -> void:
	if node is GPUParticles2D:
		node.emitting = true
		node.one_shot = false # Force it to run continuous for this frame
		
	if node is CollisionObject2D:
		node.collision_layer = 0
		node.collision_mask = 0
		
	for child in node.get_children():
		_trigger_particles(child)
