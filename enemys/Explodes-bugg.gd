extends GPUParticles2D

func initialize(sprite: Texture):
	process_material.set_shader_param('emission_box_extends', 
	Vector3(sprite.get_width() / 2.0, sprite.get_height() / 2.0, 1))
	
	process_material.set_shader_param("sprite", sprite)
	
	amount = sprite.get_width() * sprite.get_height()

	emitting = true
