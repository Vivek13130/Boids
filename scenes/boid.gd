extends CharacterBody2D


var screen_size
var acceleration = Vector2.ZERO

var margin_on_edges = manager.MARGIN_ON_EDGES
var grid_cell_size = manager.GRID_CELL_SIZE
var boids_grid = manager.boids_grid
var current_grid_pos = null

var counter = 0
var counter_outside_x = 1;
var counter_outside_y = 1;

var neighbour_boids = []

var boid_id : int 
var default_font = ThemeDB.fallback_font
var default_font_size = 15


func _ready() -> void:
	boid_id = manager.boid_count
	
	add_to_group("Boids")
	
	velocity = Vector2(randf_range(-1,1), randf_range(-1, 1))*manager.MAX_SPEED
	current_grid_pos = manager.world_to_grid_position(global_position)
	
	if not boids_grid.has(current_grid_pos):
		boids_grid[current_grid_pos] = []
	
	boids_grid[current_grid_pos].append(self)



func _process(_delta: float) -> void:
	update_boid_grid_position()
	apply_flocking()
		
	if acceleration.length() > manager.MAX_ACCELERATION :
		acceleration = acceleration.normalized() * manager.MAX_ACCELERATION
	
	# check it after acceleration capping to make sure it has dominating effect
	check_for_edges()
	velocity += acceleration 
	
	acceleration = Vector2.ZERO
	
	avoid_obstacles()
	cap_velocity()
	
	rotation = velocity.angle()
	move_and_slide()
	



func world_to_grid(position : Vector2) -> Vector2:
	return Vector2(floor(position.x / grid_cell_size), floor(position.y / grid_cell_size))


func avoid_obstacles():
	# we will look on obstacles nearby refering to obstacle grid
	# based on the distance between boid and obstacle we will add a repulsive acceleration to boid . 
	var avoidance_velocity := Vector2.ZERO
	var avoidance_weight = manager.AVOIDANCE_STRENGTH# Tune this for smooth avoidance

	var d = ceil(manager.DETECTION_RANGE / manager.GRID_CELL_SIZE)

	for i in range(-d, d + 1):
		for j in range(-d, d + 1):
			var obstacle_grid_pos = current_grid_pos + Vector2(i, j)

			if manager.obstacle_grid.has(obstacle_grid_pos):
				var obstacle_pos = manager.grid_to_world_position(obstacle_grid_pos)
				var distance = global_position.distance_to(obstacle_pos)

				if distance > 0 and distance < manager.DETECTION_RANGE * 3:
					var repulsion_vector = (global_position - obstacle_pos).normalized() / distance
					avoidance_velocity += repulsion_vector * avoidance_weight

	velocity += avoidance_velocity * 2


func cap_velocity() -> void : 
	if(velocity.length() < manager.MIN_SPEED):
		velocity = velocity.normalized() * manager.MIN_SPEED
	
	if(velocity.length() > manager.MAX_SPEED):
		velocity = velocity.normalized() * manager.MAX_SPEED


func check_for_edges() -> void:
	var curr_pos = global_position
	screen_size = get_viewport().size
	
	var edge_threshold = manager.MARGIN_ON_EDGES  
	var edge_force_strength = manager.EDGE_FORCE_STRENGTH 
	
	# applying acceleration to keep boids in the screen
	
	if curr_pos.x < edge_threshold:
		var dist = edge_threshold - curr_pos.x
		acceleration.x += dist * edge_force_strength
	elif curr_pos.x > screen_size.x - edge_threshold:
		var dist = curr_pos.x - (screen_size.x - edge_threshold)
		acceleration.x -= dist * edge_force_strength
	
	if curr_pos.y < edge_threshold:
		var dist = edge_threshold - curr_pos.y
		acceleration.y += dist * edge_force_strength
	elif curr_pos.y > screen_size.y - edge_threshold:
		var dist = curr_pos.y - (screen_size.y - edge_threshold)
		acceleration.y -= dist * edge_force_strength


func update_boid_grid_position() -> void :
	var new_grid_pos = manager.world_to_grid_position(global_position)
	# remove the boid from it's old cell (if it has moved to a new cell):
	if new_grid_pos != current_grid_pos:
		#creating a new entry in the grid
		if not boids_grid.has(new_grid_pos):
			boids_grid[new_grid_pos] = []
		
		boids_grid[current_grid_pos].erase(self)
		
		# removing the cell from grid if it is empty 
		if boids_grid[current_grid_pos].is_empty():
			boids_grid.erase(current_grid_pos)
		
		current_grid_pos = new_grid_pos
		boids_grid[new_grid_pos].append(self)


func apply_flocking()->void:
	get_neighbours()
	
	if neighbour_boids.size() > 0 :
		apply_cohesion()
		apply_seperation()
		apply_alignment()



# getting neighbours with field of view
func get_neighbours() -> void:
	var FOV_ANGLE = manager.FOV  
	var FOV_RADIUS = manager.DETECTION_RANGE  

	neighbour_boids.clear()
	
	var half_fov = FOV_ANGLE / 2.0
	var fov_cos_threshold = cos(deg_to_rad(half_fov))  # Precompute
	
	# Check if velocity is valid before normalizing
	var velocity_norm = velocity.normalized() if velocity.length() > 0 else Vector2.ZERO
	
	# Grid search optimization
	var d = ceil(FOV_RADIUS / manager.GRID_CELL_SIZE)
	
	for i in range(-d, d + 1):
		for j in range(-d, d + 1):
			var neighbour_grid_pos = current_grid_pos + Vector2(i, j)
			
			if boids_grid.has(neighbour_grid_pos):
				for nb in boids_grid[neighbour_grid_pos]:
					if nb == self:
						continue  # Skip self

					# Distance check
					var distance = global_position.distance_to(nb.global_position)
					if distance > FOV_RADIUS:
						continue

					# Direction and angle check
					var direction_to_neighbour = (nb.global_position - global_position).normalized()
					if velocity_norm != Vector2.ZERO and velocity_norm.dot(direction_to_neighbour) > fov_cos_threshold:
						neighbour_boids.append(nb)



func apply_cohesion()->void : 
	var sum_of_positions = Vector2.ZERO
	
	for boid in neighbour_boids:
		sum_of_positions += boid.global_position
	
	var avg_position = sum_of_positions / neighbour_boids.size()
	acceleration += (avg_position - global_position)* manager.COHESION
	return 


func apply_seperation() -> void :
	var stable_seperation = manager.SEPERATION_DISTANCE
	var seperation_acc = Vector2.ZERO
	
	for boid in neighbour_boids:
		var distance = global_position.distance_to(boid.global_position)
		if distance <= stable_seperation:
			var distMultiplier = 1 - (distance / stable_seperation)
			
			var direction = (global_position - boid.global_position).normalized()
			acceleration += direction * distMultiplier * manager.SEPERATION_SENSITIVITY
	
	return

func apply_alignment() -> void :
	var sum_of_velocity = Vector2.ZERO
	
	for boid in neighbour_boids:
		sum_of_velocity += boid.velocity
	
	var avg_velocity = sum_of_velocity / neighbour_boids.size()
	acceleration += (avg_velocity - velocity) * manager.ALIGNMENT
	return



func apply_noise():
	pass
