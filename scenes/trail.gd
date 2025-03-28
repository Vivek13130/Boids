extends Line2D


func _ready() -> void:
	position = Vector2.ZERO  
	rotation = 0 

func _process(delta: float) -> void:
	if manager.TRAIL_ENABLED == false or manager.TRAIL_LENGTH == 0:
		clear_points()
		return
	
	var boid_position = to_local(get_parent().global_position)
	add_point(boid_position)

	while get_point_count() > manager.TRAIL_LENGTH:
		remove_point(0)


# implement noise addon on trail points 
