extends Node

#other const : 
const GRID_CELL_SIZE = 100
const BOID_COLOR = Color(1.0, 0.0, 0.0)

#some constants for the boids 
const COHESION = 0.1 # ranges between 0 to 1
const ALIGNMENT = 0.5 # ranges between 0 to 1
const SEPERATION_DISTANCE = 200 # min stable distance between any two boids
const SEPERATION_SENSITIVITY = 3 # how aggressively boids react to the seperation
const NOISE = 0

const FLOCKING_UPDATE_LATENCY = 10 # every x frames , new flocking will be applied
# this will increase the performance

#movement constants
const MIN_SPEED = 200
const MAX_SPEED = 500

const MAX_ACCELERATION = 500

const REPULSION_ON_EDGES = 30
const MARGIN_ON_EDGES = GRID_CELL_SIZE

const VIEW_ANGLE = 360
const DETECTION_RANGE = 100 

var boids_grid = {}


func world_to_grid_position(position : Vector2) -> Vector2:
	return Vector2(floor(position.x / GRID_CELL_SIZE), floor(position.y / GRID_CELL_SIZE))
