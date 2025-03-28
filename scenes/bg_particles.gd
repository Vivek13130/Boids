extends CPUParticles2D

func _ready():
	emitting = true
	update_rect_extents()
	get_viewport().connect("size_changed", update_rect_extents) # Update on resize

func update_rect_extents():
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2  # Center the particles
	emission_rect_extents = viewport_size / 2  # Cover the entire viewport
