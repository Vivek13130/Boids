extends Line2D

@export var trail_length: int = 50  # Adjust this to your desired trail length

func _ready() -> void:
	width = 2
	default_color = Color(1, 0, 0)  # Adjust color as needed
	position = Vector2.ZERO  # Ensure no offset
	rotation = 0  # Ensure no rotation

func _process(delta: float) -> void:
	# Get the boid's global position
	var boid_position = get_parent().global_position

	# Add the current position of the boid to the trail
	add_point(boid_position)

	# Maintain the trail length
	if get_point_count() > trail_length:
		remove_point(0)
