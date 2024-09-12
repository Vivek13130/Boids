extends Line2D


func _ready() -> void:
	#width = 1
	#default_color = Color(1, 0, 0)  # Adjust color as needed
	position = Vector2.ZERO  # Ensure no offset
	rotation = 0  # Ensure no rotation

func _process(delta: float) -> void:
	if manager.TRAIL_ENABLED == false or manager.TRAIL_LENGTH == 0:
		return
	
	# Get the boid's global position
	var boid_position = to_local(get_parent().global_position)
	# Add the current position of the boid to the trail
	add_point(boid_position)

	# Maintain the trail length
	while get_point_count() > manager.TRAIL_LENGTH:
		remove_point(0)
