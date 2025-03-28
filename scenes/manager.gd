extends Node

#other const : 
const GRID_CELL_SIZE = 64
const MARGIN_ON_EDGES = 100
const EDGE_FORCE_STRENGTH = 0.25

#default values for the boids 
const DEFAULT_COHESION = 3 # ranges between 0 to n
const DEFAULT_ALIGNMENT = 0.8 # ranges between 0 to 1
const DEFAULT_SEPERATION_DISTANCE = 100 # min stable distance between any two boids
const DEFAULT_SEPERATION_SENSITIVITY = 100 # how aggressively boids react to the seperation
const DEFAULT_NOISE = 0

#movement constants
const DEFAULT_MIN_SPEED = 100
const DEFAULT_MAX_SPEED = 400
const DEFAULT_MAX_ACCELERATION = 200


const DEFAULT_FOV = 360
const DEFAULT_DETECTION_RANGE = 50 
const DEFAULT_TRAIL_LENGTH = 50

var boids_grid := {}
var obstacle_grid := {}

#some VARIABLES connected to sliders for the boids 
var COHESION = 3 # ranges between 0 to n
var ALIGNMENT = 0.8 # ranges between 0 to 1
var SEPERATION_DISTANCE = 200 # min stable distance between any two boids
var SEPERATION_SENSITIVITY = 100 # how aggressively boids react to the seperation
var NOISE = 0


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


# obstacle placement and deletion system : 
var selected_obstacle : String = "NONE"
var AVOIDANCE_STRENGTH : int = 3000

const FORWARD_BIAS : int = 1000

var trail_effect : int = 5 # index of which trail effect is applied

var obstacle_avoidance : bool = true 
var explosive_clicks : bool = false 
var performance_matrics : bool = false 
var multithreading : bool = false 
#-------------------------------------------


func world_to_grid_position(position : Vector2) -> Vector2:
	# return the cell number (x,y)
	return Vector2(floor(position.x / GRID_CELL_SIZE), floor(position.y / GRID_CELL_SIZE))

func grid_to_world_position(grid_pos: Vector2) -> Vector2:
	# return the center of the grid cell 
	return Vector2(grid_pos.x * GRID_CELL_SIZE, grid_pos.y * GRID_CELL_SIZE) + Vector2(GRID_CELL_SIZE / 2, GRID_CELL_SIZE / 2)
