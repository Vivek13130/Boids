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



func world_to_grid_position(position : Vector2) -> Vector2:
	return Vector2(floor(position.x / GRID_CELL_SIZE), floor(position.y / GRID_CELL_SIZE))
