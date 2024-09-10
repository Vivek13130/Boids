extends CharacterBody2D


var screen_size
var acceleration = Vector2.ZERO

var margin_on_edges = manager.MARGIN_ON_EDGES
var repulsion_on_edges = manager.REPULSION_ON_EDGES

var boids_grid = manager.boids_grid
var current_grid_pos = null

var counter = 0

var neighbour_boids = []

func _ready() -> void:
	screen_size = get_viewport().size
	
	# random vel and pos in start 
	#position = Vector2(randf_range(0, screen_size.x) , randf_range(0, screen_size.y))
	velocity = Vector2(randf_range(-1,1), randf_range(-1, 1))*manager.MAX_SPEED
	
	# adding it to grid : 
	current_grid_pos = manager.world_to_grid_position(global_position)
	
	if not boids_grid.has(current_grid_pos):
		boids_grid[current_grid_pos] = []
	
	boids_grid[current_grid_pos].append(self)

func _process(delta: float) -> void:
	counter += 1
	
#	function call for boids :
	check_for_edges()
	update_boid_grid_position()
	
	if counter > manager.FLOCKING_UPDATE_LATENCY:
		counter = 0
		apply_flocking()
		
		if acceleration.length() > manager.MAX_ACCELERATION :
			acceleration = acceleration.normalized() * manager.MAX_ACCELERATION
	
	
	velocity += acceleration 
	acceleration = Vector2.ZERO
	
	if(velocity.length() < manager.MIN_SPEED):
		velocity = velocity.normalized() * manager.MIN_SPEED
	
	if(velocity.length() > manager.MAX_SPEED):
		velocity = velocity.normalized() * manager.MAX_SPEED
	
	rotation = velocity.angle()
	move_and_slide()


func check_for_edges() -> void :
	var curr_pos = global_position
	
	if(curr_pos.x < margin_on_edges):
		velocity.x += repulsion_on_edges
	elif(curr_pos.x > screen_size.x - margin_on_edges):
		velocity.x -=  repulsion_on_edges
	
	if(curr_pos.y < margin_on_edges):
		velocity.y += repulsion_on_edges
	elif(curr_pos.y > screen_size.y - margin_on_edges):
		velocity.y -= repulsion_on_edges


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

func get_neighbours()->void :
	neighbour_boids.clear()
	
	var d = ceil(manager.DETECTION_RANGE / manager.GRID_CELL_SIZE)
	
	for i in range(-d , d + 1):
		for j in range(-d , d + 1):
			var neighbour_grid_pos = current_grid_pos + Vector2(i,j)
			
			if boids_grid.has(neighbour_grid_pos):
				
				for nb in boids_grid[neighbour_grid_pos]: # nb means neighbour_boid
					if global_position.distance_to(nb.global_position) <= manager.DETECTION_RANGE:
						neighbour_boids.append(nb)
	
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
	
#	trying this one : 
	#acceleration += avg_velocity * manager.ALIGNMENT
	return
