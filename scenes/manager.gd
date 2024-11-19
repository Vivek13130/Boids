extends Node

#other const : 
const GRID_CELL_SIZE = 100
const MARGIN_ON_EDGES = 100
const EDGE_FORCE_STRENGTH = 0.25

#some default values for the boids 
const DEFAULT_COHESION = 3 # ranges between 0 to n
const DEFAULT_ALIGNMENT = 0.8 # ranges between 0 to 1
const DEFAULT_SEPERATION_DISTANCE = 100 # min stable distance between any two boids
const DEFAULT_SEPERATION_SENSITIVITY = 100 # how aggressively boids react to the seperation
const DEFAULT_NOISE = 0

const DEFAULT_FLOCKING_UPDATE_LATENCY = 0 # every x frames , new flocking will be applied
# this will increase the performance

#movement constants
const DEFAULT_MIN_SPEED = 100
const DEFAULT_MAX_SPEED = 400

const DEFAULT_MAX_ACCELERATION = 200


const DEFAULT_FOV = 360
const DEFAULT_DETECTION_RANGE = 50 
const DEFAULT_TRAIL_LENGTH = 50

var boids_grid = {}


#some VARIABLES connected to sliders for the boids 
var COHESION = 3 # ranges between 0 to n
var ALIGNMENT = 0.8 # ranges between 0 to 1
var SEPERATION_DISTANCE = 200 # min stable distance between any two boids
var SEPERATION_SENSITIVITY = 100 # how aggressively boids react to the seperation
var NOISE = 0

var FLOCKING_UPDATE_LATENCY = 10 # every x frames , new flocking will be applied
# this will increase the performance

#movement varants
var MIN_SPEED = 200
var MAX_SPEED = 500

var MAX_ACCELERATION = 500


var FOV = 360
var DETECTION_RANGE = 100
var TRAIL_LENGTH = 500
var boid_count = 0

var TRAIL_ENABLED : bool = false
var COLOR_MODE_ENABLED : bool = false

var BRIGHT_COLORS = [
	Color(1, 0, 0),     # Red
	Color(0, 1, 0),     # Green
	Color(0, 0, 1),     # Blue
	Color(1, 1, 0),     # Yellow
	Color(1, 0, 1),     # Magenta
	Color(0, 1, 1),     # Cyan
	Color(1, 0.5, 0),   # Orange
	Color(0.5, 0, 1),   # Purple
	Color(0, 1, 0.5),   # Teal
	Color(1, 0.5, 0.5), # Coral
	Color(0.5, 1, 0.5), # Lime
	Color(0.5, 0.5, 1), # Sky Blue
	Color(1, 1, 0.5),   # Light Yellow
	Color(1, 0.75, 0.5),# Peach
	Color(0.75, 1, 0.75) # Mint
]



func world_to_grid_position(position : Vector2) -> Vector2:
	return Vector2(floor(position.x / GRID_CELL_SIZE), floor(position.y / GRID_CELL_SIZE))


var flag : bool = false


#func _process(delta: float) -> void:
	## If color mode is enabled, assign random bright colors to all boids
	#if COLOR_MODE_ENABLED and !flag:
		#print("applying colors ")
		#flag = ! flag
		#apply_random_colors_to_boids(get_tree().get_nodes_in_group("Boids"))
	#else:
		#flag = false
	
	#pass

# Helper function to assign random colors to each boid
func apply_random_colors_to_boids(all_boids: Array) -> void:
	print("all boids size : " , all_boids.size())
	for boid in all_boids:
		# Assign random color using HSV for bright colors
		var hue = randf_range(0, 1)  # Random hue value between 0 and 1
		var saturation = 0.8  # High saturation to ensure brightness
		var value = 0.9  # High value for brightness
		var random_color = Color.from_hsv(hue, saturation, value)
		
		boid.set_color(random_color)  # Call a method on the boid to change its color





# applying colors to boids : 
# Cluster variables
var cluster_data = {}
var cluster_colors = {}
var cluster_counter = 0
const MAX_CLUSTERS = 10


var counter : int = 0 

# Process function
func _process(delta: float) -> void:
	if COLOR_MODE_ENABLED:
		counter += 1 
		if(counter >= 10 ):
			update_clusters(get_tree().get_nodes_in_group("Boids"))
			counter = 0 
	else:
		for boid in get_tree().get_nodes_in_group("Boids"):
			boid.set_color(Color(1, 0, 0))  # Bright red

# Update clusters dynamically
func update_clusters(all_boids: Array) -> void:
	var visited = {}  # Track visited boids
	cluster_data.clear()
	cluster_counter = 0

	# Identify clusters
	for boid in all_boids:
		if not visited.has(boid):
			var cluster = []
			explore_cluster(boid, cluster, visited)
			cluster_data[cluster_counter] = cluster
			cluster_counter += 1

	assign_colors_to_clusters()

# Explore and group clusters
func explore_cluster(boid, cluster, visited) -> void:
	visited[boid] = true
	cluster.append(boid)

	for neighbor in boid.neighbour_boids:
		if not visited.has(neighbor) and boid.global_position.distance_to(neighbor.global_position) <= DETECTION_RANGE:
			explore_cluster(neighbor, cluster, visited)

# Assign colors to clusters
#func assign_colors_to_clusters() -> void:
	#cluster_colors.clear()
#
	#for cluster_id in cluster_data.keys():
		#var hue = float(cluster_id) / MAX_CLUSTERS
		#cluster_colors[cluster_id] = Color.from_hsv(hue, 0.8, 0.9)
#
	#for cluster_id in cluster_data.keys():
		#for boid in cluster_data[cluster_id]:
			#boid.set_color(cluster_colors[cluster_id])  # Ensure boid has this function
			
			
			
func assign_colors_to_clusters() -> void:
	cluster_colors.clear()

	for cluster_id in cluster_data.keys():
		# Distribute hues evenly, but ensure it's not too similar
		var hue = float(cluster_id) / MAX_CLUSTERS
		# Set high saturation (0.8 to 1) for bright colors
		var saturation = 0.9  # Higher saturation for vivid colors
		# Set high value (0.8 to 1) for brightness
		var value = 0.9  # Higher value for brightness
		
		# Ensure hue is a random or cyclic color distribution
		cluster_colors[cluster_id] = Color.from_hsv(hue, saturation, value)

	# Apply the color to all boids in each cluster
	for cluster_id in cluster_data.keys():
		for boid in cluster_data[cluster_id]:
			boid.set_color(cluster_colors[cluster_id])  # Ensure boid has this function
