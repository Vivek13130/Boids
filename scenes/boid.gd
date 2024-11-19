extends CharacterBody2D


var screen_size
var acceleration = Vector2.ZERO

var margin_on_edges = manager.MARGIN_ON_EDGES

var boids_grid = manager.boids_grid
var current_grid_pos = null

var counter = 0
var counter_outside_x = 1;
var counter_outside_y = 1;

var neighbour_boids = []
@onready var trail: Line2D = $trail

var simplex_noise = FastNoiseLite.new()



func _ready() -> void:
	
	# random vel and pos in start 
	#position = Vector2(randf_range(0, screen_size.x) , randf_range(0, screen_size.y))
	velocity = Vector2(randf_range(-1,1), randf_range(-1, 1))*manager.MAX_SPEED
	
	# adding it to grid : 
	current_grid_pos = manager.world_to_grid_position(global_position)
	
	if not boids_grid.has(current_grid_pos):
		boids_grid[current_grid_pos] = []
	
	boids_grid[current_grid_pos].append(self)
	

func _process(_delta: float) -> void:
	counter += 1
	
	update_boid_grid_position()
	
	
	if counter > manager.FLOCKING_UPDATE_LATENCY:
		counter = 0
		apply_flocking()
		
		if acceleration.length() > manager.MAX_ACCELERATION :
			acceleration = acceleration.normalized() * manager.MAX_ACCELERATION
	
	
	check_for_edges()
	velocity += acceleration 
	acceleration = Vector2.ZERO
	
	if(velocity.length() < manager.MIN_SPEED):
		velocity = velocity.normalized() * manager.MIN_SPEED
	
	if(velocity.length() > manager.MAX_SPEED):
		velocity = velocity.normalized() * manager.MAX_SPEED
	
	rotation = velocity.angle()
	move_and_slide()


func check_for_edges() -> void:
	var curr_pos = global_position
	screen_size = get_viewport().size
	
	# Define the distance from edges to start applying force
	var edge_threshold = manager.MARGIN_ON_EDGES  
	# Define the repulsion force factor
	var edge_force_strength = manager.EDGE_FORCE_STRENGTH 
	
	# Apply a smooth force to keep boids inside the screen
	if curr_pos.x < edge_threshold:
		var dist = edge_threshold - curr_pos.x
		velocity.x += dist * edge_force_strength
	elif curr_pos.x > screen_size.x - edge_threshold:
		var dist = curr_pos.x - (screen_size.x - edge_threshold)
		velocity.x -= dist * edge_force_strength
	
	if curr_pos.y < edge_threshold:
		var dist = edge_threshold - curr_pos.y
		velocity.y += dist * edge_force_strength
	elif curr_pos.y > screen_size.y - edge_threshold:
		var dist = curr_pos.y - (screen_size.y - edge_threshold)
		velocity.y -= dist * edge_force_strength
	
	# Reapply velocity caps
	if velocity.length() < manager.MIN_SPEED:
		velocity = velocity.normalized() * manager.MIN_SPEED
	elif velocity.length() > manager.MAX_SPEED:
		velocity = velocity.normalized() * manager.MAX_SPEED



func update_boid_grid_position() -> void :
	var new_grid_pos = manager.world_to_grid_position(global_position)
	
#	creating a new entry in the grid
	if not boids_grid.has(new_grid_pos):
		boids_grid[new_grid_pos] = []
	
	# remove the boid from it's old cell (if it has moved to a new cell):
	if new_grid_pos != current_grid_pos:
		boids_grid[current_grid_pos].erase(self)
		current_grid_pos = new_grid_pos
		# Add the boid to the new grid cell
		boids_grid[new_grid_pos].append(self)


func apply_flocking()->void:
	get_neighbours()
	
	if neighbour_boids.size() > 0 :
		apply_cohesion()
		apply_seperation()
		apply_alignment()
		
		
		

#func get_neighbours()->void :
	#neighbour_boids.clear()
	#
	#var d = ceil(manager.DETECTION_RANGE / manager.GRID_CELL_SIZE)
	#
	#for i in range(-d , d + 1):
		#for j in range(-d , d + 1):
			#var neighbour_grid_pos = current_grid_pos + Vector2(i,j)
			#
			#if boids_grid.has(neighbour_grid_pos):
				#
				#for nb in boids_grid[neighbour_grid_pos]: # nb means neighbour_boid
					#if global_position.distance_to(nb.global_position) <= manager.DETECTION_RANGE:
						#neighbour_boids.append(nb)
	#
	#neighbour_boids.erase(self)
	#
	#return 
	
var FOV_ANGLE = manager.FOV  # Field of view angle in degrees (adjust as needed)
var FOV_RADIUS = manager.DETECTION_RANGE  # Radius of detection (same as before)

# getting neighbours with field of view
func get_neighbours() -> void:
	neighbour_boids.clear()
	
	# Calculate the half FOV angle (for easier comparison)
	var half_fov = FOV_ANGLE / 2.0
	
	# Convert the FOV angle to radians for comparison
	var fov_radians = deg_to_rad(half_fov)
	
	# Calculate the grid cells to check around the current boid's position
	var d = ceil(manager.DETECTION_RANGE / manager.GRID_CELL_SIZE)
	
	for i in range(-d, d + 1):
		for j in range(-d, d + 1):
			var neighbour_grid_pos = current_grid_pos + Vector2(i, j)
			
			if boids_grid.has(neighbour_grid_pos):
				
				for nb in boids_grid[neighbour_grid_pos]:  # nb means neighbour_boid
					# Calculate distance to the potential neighbor boid
					var distance = global_position.distance_to(nb.global_position)
					
					if distance <= FOV_RADIUS:
						# Calculate the angle between the boid's velocity and the vector to the neighbor
						var direction_to_neighbour = (nb.global_position - global_position).normalized()
						var angle_to_neighbour = direction_to_neighbour.angle_to(velocity.normalized())
						
						# If the angle is within the FOV, consider it a valid neighbor
						if abs(angle_to_neighbour) <= fov_radians:
							neighbour_boids.append(nb)
	
	# Remove the current boid from the neighbor list
	neighbour_boids.erase(self)
	
	return


	
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


# Member variables
var noise_time_x = 0.0
var noise_time_y = 0.0

func apply_noise():
	
	# not working yet 
	var noise_strength = manager.NOISE_STRENGTH  # Adjustable intensity
	var noise_speed = manager.NOISE_SPEED       # How fast the noise changes
	
	# Increment time for smooth variation
	noise_time_x += noise_speed
	noise_time_y += noise_speed
	
	# Use Perlin noise for gradual directional changes
	var noise_x = simplex_noise.get_noise_1d(noise_time_x)
	var noise_y = simplex_noise.get_noise_1d(noise_time_y)
	
	var noise = Vector2(noise_x, noise_y).normalized()
	acceleration += noise * noise_strength
