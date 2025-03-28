extends Line2D


@export var amplitude: float = 2.0 
@export var frequency: float = 100.0   
@export var noise_intensity: float = 2.0  
@export var flicker_intensity: float = 5.0  

var noise := FastNoiseLite.new()


func _ready() -> void:
	position = Vector2.ZERO  
	rotation = 0 
	noise.seed = randi()  # Randomize noise


func _process(delta: float) -> void:
	if manager.TRAIL_ENABLED == false or manager.TRAIL_LENGTH == 0:
		clear_points()
		return
	
	var boid_position = to_local(get_parent().global_position)

	# Ensure a minimum distance between consecutive points
	if get_point_count() == 0 or boid_position.distance_to(get_point_position(get_point_count() - 1)) > 5.0:
		add_point(boid_position)

	while get_point_count() > manager.TRAIL_LENGTH:
		remove_point(0)

	match manager.trail_effect :
		0 : 
			apply_perlin_noise()
		1 : 
			apply_flicker()
		2 : 
			apply_spiral_effect() 
		3 : 
			apply_spiral_distorted()
		4 : 
			apply_pixel_shatter()


func apply_pixel_shatter():
	var points = get_points()
	
	for i in range(0, points.size(), 5):  # Process every 5th point
		var pixel = ColorRect.new()
		var pixel1 = ColorRect.new()
		
		pixel.color = Color(randf(), randf(), randf())
		pixel.size = Vector2(4, 4)
		pixel.position = points[i] - Vector2(2, 2)
		add_child(pixel)
		
		pixel1.color = Color(randf(), randf(), randf())
		pixel1.size = Vector2(4, 4)
		pixel1.position = points[i] - Vector2(2, 2)
		add_child(pixel1)
		
		# Animate
		var tween = create_tween()
		tween.tween_property(pixel, "position:y", pixel.position.y - 30, 0.5)
		tween.parallel().tween_property(pixel, "modulate:a", 0.0, 0.5)
		tween.finished.connect(pixel.queue_free)
		
		var tween1 = create_tween()
		tween1.tween_property(pixel1, "position:y", pixel1.position.y + 30, 0.5)
		tween1.parallel().tween_property(pixel1, "modulate:a", 0.0, 0.5)
		tween1.finished.connect(pixel1.queue_free)


func apply_spiral_effect(strength: float = 0.3, rotation_speed: float = 35.0) -> void:
	var center = get_point_position(get_point_count() - 1)  # Latest point
	var time = Time.get_ticks_msec() / 1000.0
	var valid_points = max(0 , get_point_count() - 3)
	
	for i in range(0, valid_points):
		var point = get_point_position(i)
		var angle = (i * strength) + (time * rotation_speed)
		var offset = Vector2(cos(angle), sin(angle)) * (i * 0.1)
		set_point_position(i, point + offset)


func apply_perlin_noise():
	for i in range(get_point_count()):
		var point = get_point_position(i)
		var noise_offset = noise.get_noise_2d(point.x, point.y) * noise_intensity
		point.x += noise_offset  # Add slight noise to x for randomness
		set_point_position(i, point)


func apply_spiral_distorted():
	var skip_points = min(2, get_point_count())
	var total_points = get_point_count()
	if total_points <= skip_points:
		return  

	for i in range(skip_points, total_points):
		var point = get_point_position(i)

		# Get normalized position in trail
		var t = float(i - skip_points) / (total_points - skip_points)  

		# Faster time shift based on boid speed (multiplier increased)
		var time_shift = Time.get_ticks_msec() * 0.005  

		# Introduce spacing factor based on distance from previous point
		var spacing_factor = 1.0 + (i - skip_points) * 0.1  

		var spiral_offset = Vector2(
			cos(t * TAU * frequency + time_shift * spacing_factor) * amplitude, 
			sin(t * TAU * frequency + time_shift * spacing_factor) * amplitude
		)

		point += spiral_offset  
		set_point_position(i, point)


func apply_flicker(): # works perfect
	var skip_points = min(2, get_point_count())
	var total_points = get_point_count()
	if total_points <= skip_points:
		return  

	for i in range(0, total_points - skip_points):
		var point = get_point_position(i)

		var flicker_offset = Vector2(
			(randf() - 0.5) * amplitude * 2.0,  
			(randf() - 0.5) * amplitude * 2.0  
		)

		point += flicker_offset  
		set_point_position(i, point)
