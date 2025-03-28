extends Node2D

const boid_scene : PackedScene = preload("res://scenes/boid.tscn")
@onready var boid_manager: Node2D = $CanvasLayer/boid_manager
@onready var obstacle_manager: Node2D = $CanvasLayer/obstacle_manager
@export var explosive_click: PackedScene

var cell_size = manager.GRID_CELL_SIZE
var grid = manager.boids_grid

func _ready():
	queue_redraw()


func _process(delta: float) -> void:
	if Input.is_action_pressed("spawn_boid"):
		spawn_boid(1)
	
	if Input.is_action_just_pressed("restart"):
		reset_boids()
	
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func _input(event):
	if event is InputEventMouseButton and event.pressed and manager.explosive_clicks:
		apply_explosive_force(event.position, 2 , 500.0)


func apply_explosive_force(mouse_position: Vector2, explosion_grid_radius : int ,max_force: float) -> void:
	var affected_boids = get_boids_in_radius(mouse_position, explosion_grid_radius)
	
	print("applied on : ", affected_boids.size())
	
	var explosion_particles = explosive_click.instantiate()
	explosion_particles.global_position = mouse_position 
	$CanvasLayer.add_child(explosion_particles)
	explosion_particles.emitting = true 
	explosion_particles.finished.connect(explosion_particles.queue_free)
	
	for boid in affected_boids:
		var direction = (boid.global_position - mouse_position).normalized()
		var force_magnitude = max_force * 10
		boid.velocity += direction * force_magnitude  # Apply impulse


func get_boids_in_radius(center: Vector2 , grid_radius : int) -> Array:
	var nearby_boids = []
	
	var current_cell = manager.world_to_grid_position(center)
	
	for x in range(-grid_radius, grid_radius + 1):
		for y in range(-grid_radius, grid_radius + 1):
			var cell_key = current_cell + Vector2(x,y)
			if grid.has(cell_key):  
				for boid in grid[cell_key]:
					nearby_boids.append(boid)
	
	return nearby_boids



func toggle_pause():
	if Engine.time_scale == 1.0:
		Engine.time_scale = 0.0  # Pause the game
	else:
		Engine.time_scale = 1.0  # Unpause the game


func reset_boids() -> void:
	for boid in boid_manager.get_children():
		boid.queue_free()
	manager.boid_count = 0


func spawn_boid(x : int) -> void:
	manager.boid_count += x
	for i in range(x):
		var new_boid = boid_scene.instantiate()
		new_boid.position = get_global_mouse_position()
		boid_manager.add_child(new_boid)


func despawn_boid(x: int) -> void:
	# not working -----------------------XXXXXXXXXXXXXXXXXXX
	var all_boids = boid_manager.get_children()
	var remove_count = min(x, all_boids.size())

	for i in range(remove_count):
		all_boids[i].queue_free()  # No need to manually remove
		manager.boid_count -= 1  # Adjust count inside loop

var obstacle_texture_paths := {
	"center": "res://assets/center.png",
	"top-left": "res://assets/top-left.png",
	"top-right": "res://assets/top-right.png",
	"bottom-right": "res://assets/bottom-right.png",
	"bottom-left": "res://assets/bottom-left.png"
}



func place_obstacle(obstacle_name: String, mouse_pos: Vector2) -> void:
	var grid_cell = manager.world_to_grid_position(mouse_pos) 

	# Prevent placing multiple obstacles on the same grid cell
	if manager.obstacle_grid.has(grid_cell):
		return
	
	var grid_pos = Vector2(grid_cell.x * manager.GRID_CELL_SIZE, grid_cell.y * manager.GRID_CELL_SIZE) + Vector2(manager.GRID_CELL_SIZE / 2, manager.GRID_CELL_SIZE / 2)
	print("placed here:", grid_pos)

	var obstacle = Sprite2D.new()
	obstacle.texture = load(obstacle_texture_paths[obstacle_name])
	obstacle.global_position = grid_pos
	obstacle_manager.add_child(obstacle)

	manager.obstacle_grid[grid_cell] = 1
	print("added:", grid_cell)


var grid_size: int = manager.GRID_CELL_SIZE  # Adjust to match manager.GRID_CELL_SIZE
@export var grid_color: Color = Color(0.2, 0.2, 0.2, 0.5)  # Semi-transparent grid

func _draw() -> void: # draw a grid
	var screen_size = get_viewport_rect().size

	for x in range(0, screen_size.x, grid_size):
		draw_line(Vector2(x, 0), Vector2(x, screen_size.y), grid_color)
	for y in range(0, screen_size.y, grid_size):
		draw_line(Vector2(0, y), Vector2(screen_size.x, y), grid_color)
