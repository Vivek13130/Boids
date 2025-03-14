extends Node2D

const boid_scene : PackedScene = preload("res://scenes/boid.tscn")
@onready var boid_manager: Node2D = $CanvasLayer/boid_manager
@onready var obstacle_manager: Node2D = $CanvasLayer/obstacle_manager




func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if Input.is_action_pressed("spawn_boid"):
		spawn_boid(1)
	
	if Input.is_action_just_pressed("restart"):
		reset_boids()

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

func place_obstacle(obstacle_name : String , mouse_pos : Vector2) -> void : 
	var grid_pos = mouse_pos.snapped(Vector2(manager.GRID_CELL_SIZE, manager.GRID_CELL_SIZE))  # Adjust grid size if needed
	
	# Prevent placing multiple obstacles on the same grid cell
	if manager.obstacle_grid.has(grid_pos):
		return
	
	grid_pos += Vector2(manager.GRID_CELL_SIZE/2, manager.GRID_CELL_SIZE/2)
	print("placed here : " , mouse_pos)
	# Create a new obstacle sprite
	var obstacle = Sprite2D.new()
	obstacle.texture = load(obstacle_texture_paths[obstacle_name])
	obstacle.global_position = grid_pos
	obstacle_manager.add_child(obstacle)
	
	# Store in the obstacle grid
	manager.obstacle_grid[grid_pos] = 1 # no point of storing it's name 
	# just store the presence as 1 and absence as 0.
